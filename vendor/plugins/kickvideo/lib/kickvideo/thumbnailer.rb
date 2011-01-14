module Kickvideo #:nodoc:
  class Thumbnailer < Processor
    # Processor options are:
    # * +position+: Where to grab the frame, measured in seconds. Defaults to 1.
    # * +format+: The output picture type, e.g. :jpg, :png, :gif
    def initialize(*args, &block)
      super
      options[:position] ||= 5
      options[:geometry] ||= '160x120'
    end

    def make
      return unless inspector.video?

      Paperclip::Tempfile.new("#{@file.path}.#{options[:format]}").tap do |dst|
        dst.binmode
        run ffmpeg_command(dst.path)
      end
    end

    protected

      def ffmpeg_command(out)
        "ffmpeg -i #{@file.path} -s #{options[:geometry]} -ss #{options[:position]} -vframes 1 -f image2 -vcodec png #{out}"
      end
  end
end
