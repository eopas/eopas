require File.dirname(__FILE__) + '/test_helper'

class DelayedS3Test < Kickvideo::TestCase
  # load s3 credentials, if any
  s3_yml = File.dirname(__FILE__) + '/s3.yml'
  @@s3 = YAML::load(IO.read(s3_yml)).symbolize_keys!
  @@s3 ||= {:access_key_id => 'foo', :secret_access_key => 'bar', :bucket => 'kickvideo-test'}
  
  context "an attachment with DelayedS3 storage" do
    setup do
      @options = {
        :storage => :delayed_s3,
        :path => ":attachment/:id/:basename-:style.:extension",
        :s3_credentials => @@s3
      }
      @v = Video.create
      @attachment = Paperclip::Attachment.new(:file, @v, {:validations => []}.merge(@options))
      @ds3 = @attachment.storage
    end
    
    should "configure the @filesystem storage" do
      assert_equal ":rails_root/public/#{@options[:path]}", @ds3.instance_variable_get("@filesystem").instance_variable_get("@path")
    end
    
    should "configure the @s3 storage" do
      assert_equal @options[:path], @ds3.instance_variable_get("@s3").instance_variable_get("@path")
      assert_equal @options[:s3_credentials], @ds3.instance_variable_get("@s3").instance_variable_get("@s3_credentials")
      assert_equal @options[:s3_credentials][:bucket], @ds3.instance_variable_get("@s3").bucket_name
    end
    
    context "writing a file to disk" do
      setup do
        @attachment.expects(:original_filename).returns('hello_world_4x3_tiny.mp4').at_least_once
        @ds3.write(:original, File.new('test/fixtures/hello_world_4x3_tiny.mp4').to_tempfile)
      end

      teardown do
        @attachment.destroy
      end

      should "truly write the style to disk" do
        assert File.exists?(@ds3.queue_dir + @ds3.path(:original))
      end

      should "have a s3 url" do
        assert @attachment.url(:original).match(/s3\.amazonaws\.com/)
      end
      
      should "not upload to s3" do
        assert ! AWS::S3::S3Object.exists?(@ds3.path(:original), @ds3.bucket_name)
      end
      
      should_change "the style's existence", :to => true do
        @ds3.exists? :original
      end
      
      should_change "delayed job's queue to upload the style to s3", :by => 1 do
        Delayed::Job.count
      end
      
      should "not copy the style for #to_file" do
        assert_equal @ds3.queue_dir + @ds3.path(:original), @ds3.to_file(:original).path
      end

      context "and then deleting" do
        setup do
          @ds3.delete(@ds3.path(:original))
        end
        
        should "truly delete the style from disk" do
          assert !File.exists?(@ds3.queue_dir + @ds3.path(:original))
        end
        
        should_change "the style's existence", :to => false do
          @ds3.exists? :original
        end
        
        should_change "#to_file", :to => nil do
          @ds3.to_file :original
        end
      end

      context "and then uploading to s3" do
        setup do
          @ds3.move_to_s3(:original)
        end

        should "remove the style from disk" do
          assert !File.exists?(@ds3.queue_dir + @ds3.path(:original))
        end

        should "add the style to s3" do
          assert AWS::S3::S3Object.exists?(@ds3.path(:original), @ds3.bucket_name)
        end

        should_not_change "the style's existence" do
          @ds3.exists? :original
        end

        should "copy the style for #to_file" do
          assert @ds3.to_file(:original).is_a?(Tempfile)
        end

        context "and deleting" do
          setup do
            @ds3.delete(@ds3.path(:original))
          end
          
          should "remove the style from s3" do
            assert !AWS::S3::S3Object.exists?(@ds3.path(:original), @ds3.bucket_name)
          end

          should_change "the style's existence", :to => false do
            @ds3.exists? :original
          end

          should_change "#to_file", :to => nil do
            @ds3.to_file :original
          end
        end
      end
    end
  end
end
