module Kickvideo #:nodoc:
  class Thumbnailer < Processor
    # Processor options are:
    # * +position+: Where to grab the frame, measured in seconds. Defaults to 1.
    # * +format+: The output picture type, e.g. :jpg, :png, :gif
    def initialize(*args, &block)
      super
      options[:position] ||= 1
    end

    def make
      return unless inspector.video?
      return unless [:jpg, :png, :gif].include?(options[:format])

      returning Paperclip::Tempfile.new("#{@file.path}.#{options[:format]}") do |dst|
        dst.binmode
        run ffmpeg_command(dst.path)
      end
    end

    protected

      def ffmpeg_command(out)
        "ffmpeg -i #{@file.path} -ss #{options[:position]} -vframes 1 #{out}"
      end
  end
end
