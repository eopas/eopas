module Paperclip::Storage #:nodoc:
  # NOTE: this is an experimental storage engine that requires 
  # http://github.com/thoughtbot/paperclip/issues/145 which has
  # not yet been merged into Paperclip.
  #
  # ---
  #
  # Stores a file locally until it may be uploaded to S3 by a background process.
  #
  # Takes all the same options as :s3 storage (see Paperclip::Storage::S3). In addition
  # it requires a :queue_dir that will store files locally before they are uploaded
  # into s3.
  # * +queue_dir+: The directory to contain files queued for upload into S3. The files
  #   will be organized here with the same +path+ as they will in S3. Defaults to
  #   ":rails_root/public". Note that this may not contain a :style interpolation.
  class DelayedS3 < Base
    def initialize(attachment, options)
      @queue_dir = (options.delete(:queue_dir) || ":rails_root/public").sub(/([^\/])$/, '\1/')

      @s3 = Paperclip::Storage::S3.new(attachment, options)
      @filesystem = Paperclip::Storage::Filesystem.new(attachment, options.merge(:path => @queue_dir + options[:path]))
    end

    def exists?(style)
      @filesystem.exists?(style) || @s3.exists?(style)
    end

    def path(style)
      @s3.path(style)
    end

    def queue_dir
      Paperclip::Interpolations.interpolate(@queue_dir, @attachment, nil)
    end

    def to_file(style)
      if @filesystem.exists?(style)
        @filesystem.to_file(style)
      elsif @s3.exists?(style)
        @s3.to_file(style)
      end
    end

    # When a file is first saved, it goes to the Filesystem only.
    def write(style, file)
      @filesystem.write(style, file)

      send_later :move_to_s3, style
    end

    # When a file is deleted, check both storage devices.
    def delete(path)
      @filesystem.delete(queue_dir + path)
      @s3.delete(path)
    end
  
    # Uploads into S3  
    def move_to_s3(style)
      file = to_file(style)
      @s3.write(style, file)
      @filesystem.delete(@filesystem.path(style))
    end
    
    # delegate remaining methods to S3 storage
    def method_missing(name, *args, &block)
      @s3.respond_to?(name) ?
        @s3.send(name, *args, &block) :
        super
    end
  end
end
