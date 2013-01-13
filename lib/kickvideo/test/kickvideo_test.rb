require File.dirname(__FILE__) + '/test_helper'

class KickvideoTest < Kickvideo::TestCase
  class Video < ActiveRecord::Base
    has_attached_file :file, :styles => {
      :standard => {
        :geometry => '400x300',
        :processors => [ :kickvideo_encoder ]
      }
    }
    validates_attached_video :file
  end

  context "creating a video with a file" do
    setup do
      @video = Video.create(:file => File.new(File.dirname(__FILE__) + '/fixtures/hello_world_4x3.mp4', 'r'))
    end

    should "be valid" do
      assert @video.valid?, @video.errors.full_messages
    end

    should_change "the number of videos" do Video.count end
    should "save the file" do
      assert @video.file.exists?
      assert_equal "./test/rails/public/system/files/#{@video.id}/original/hello_world_4x3.mp4", @video.file.path
    end

    teardown do
      @video.file.destroy if @video and @video.file.exists?
    end
  end

  context "creating a video with bad ffmpeg arguments" do
    setup do
      Paperclip::KickvideoEncoder::VIDEO_PROFILES[:default] += ' -doesnotexist'
    end

    teardown do
      Paperclip::KickvideoEncoder::VIDEO_PROFILES[:default].sub!(/ -doesnotexist/, '')
    end

    should "raise an error" do
      assert_raises Kickvideo::ProcessingError do
        Video.create(:file => File.new(File.dirname(__FILE__) + '/fixtures/hello_world_4x3.mp4', 'r'))
      end
    end

    should "send a notification" do
      ActionMailer::Base.deliveries = []
      Video.create(:file => File.new(File.dirname(__FILE__) + '/fixtures/hello_world_4x3.mp4', 'r')) rescue Kickvideo::ProcessingError
      assert ActionMailer::Base.deliveries.last.subject.match(/\[KICKVIDEO\]/)
    end
  end

  context "a video from a text file" do
    setup do
      @txt = Tempfile.new('text')
      @txt << 'hello world'
      @video = Video.new(:file => @txt)
    end

    should "not be valid" do
      assert !@video.valid?
      assert @video.errors.on(:file_content_type)
    end
  end

  context "padding" do
    should "letterbox from wide to full" do
      assert_equal [16, 0, 16, 0], Paperclip::KickvideoEncoder.padding('320x180', '160x120')
    end

    should "pillarbox from full to wide" do
      assert_equal [0, 20, 0, 20], Paperclip::KickvideoEncoder.padding('320x240', '160x90')
    end

    should "gracefully pad non-standard sizes" do
      assert_equal [0, 50, 0, 50], Paperclip::KickvideoEncoder.padding('100x100', '400x300')
      assert_equal [12, 0, 12, 0], Paperclip::KickvideoEncoder.padding('400x300', '100x100')
    end

    should "not pad between the same ratios" do
      assert_equal [0, 0, 0, 0], Paperclip::KickvideoEncoder.padding('400x300', '160x120')
    end
  end

  class VideoThumbnail < ActiveRecord::Base
    set_table_name 'videos'

    has_attached_file :file, :styles => {
      :thumb => {
        :format => 'jpg',
        :geometry => '40x30',
        :processors => [ :kickvideo_thumbnailer, :thumbnail ]
      }
    }
  end

  context "extracting and resizing a thumbnail from a video" do
    setup do
      @video = VideoThumbnail.create(:file => File.new(File.dirname(__FILE__) + '/fixtures/hello_world_4x3.mp4', 'r'))
    end

    teardown do
      @video.file.destroy if @video and @video.file.exists?
    end

    should "create an image" do
      assert `identify #{@video.file.path(:thumb)}`.match(/JPEG/)
    end

    should "resize properly" do
      assert `identify #{@video.file.path(:thumb)}`.match(/40x30/)
    end
  end
end
