module Kickvideo #:nodoc:
  class Encoder < Processor
    VIDEO_PROFILES = {
      # Default settings should be safe for any install. This is a one-pass
      # bitrate optimization. Nothing great.
      :default  => "-b 512k -bt 512k -r 30 -threads 0 -vcodec libtheora",
      # Bitrate tries to create a specific file size. Best used with two-pass.
      :h264     => "-vcodec libx264 -b 512k -bt 512k -vpre hq -threads 0",
      # CRF tries to preserve a given perceptual quality throughout, which
      # means compressing high-motion or complex scenes where the human eye
      # can't pick out as much anyway. Constant bit-rates are better for
      # streaming though, so this is not likely desired in a Rails application.
      :h264_crf => "-vcodec libx264 -crf 22 -vpre hq -threads 0"
    }

    AUDIO_PROFILES = {
      # Default should work with any install.
      :default => "-ar 22050 -ab 64k -async 2 -acodec libvorbis",
      # MP3 codec. Should also be pretty safe.
      :mp3     => "-ar 22050 -ab 64k -async 2 -acodec libmp3lame",
      # AAC requires a lib that may not be available by default.
      :aac     => "-ar 22050 -ab 64k -async 2 -acodec libfaac"
    }

    # Processor options are:
    # * +video_profile+: Which Paperclip::KickvideoEncoder::VIDEO_PROFILES to use.
    # * +audio_profile+: Which Paperclip::KickvideoEncoder::AUDIO_PROFILES to use.
    # * +format+: What container (and therefore extension) to use for the file. Defaults to MP4.
    # * +two_pass+: Whether to enable two-pass encoding. Default is false.
    def initialize(*args, &block)
      super
      options[:video_profile] ||= :default
      options[:audio_profile] ||= :default
      options[:format]        ||= :ogg
      options[:two_pass]      ||= false
    end

    def make
      return unless inspector.video?
      return if [:jpg, :png, :gif].include?(options[:format])

      returning Paperclip::Tempfile.new(@file.path + '-encoded') do |dst|
        dst.binmode
        run ffmpeg_command(dst.path)
        run qt_faststart(dst.path) if needs_qt_faststart?
      end
    end

    # accepts string geometries like '400x300', and returns the padding necessary to convert aspect ratios
    # in a [top, right, bottom, left] format similar to css.
    #
    # assumes that padding will be applied AFTER resizing.
    def self.padding(source, target)
      source = Kickvideo::Geometry.new(*source.split('x'))
      target = Kickvideo::Geometry.new(*target.split('x'))

      # going from wide to full: letterboxing
      if source.aspect > target.aspect
        scale = target.width / source.width
        padding = (target.height - scale * source.height).to_i / 2
        padding += 1 unless padding % 2 == 0
        [padding, 0, padding, 0]

      # going from full to wide: pillarboxing
      elsif source.aspect < target.aspect
        scale = target.height / source.height
        padding = (target.width - scale * source.width).to_i / 2
        padding += 1 unless padding % 2 == 0
        [0, padding, 0, padding]
      else
        [0, 0, 0, 0]
      end
    end

    protected

      def ffmpeg_command(out)
        padding = self.class.padding(inspector.resolution, options[:geometry])
        target  = Kickvideo::Geometry.new(*options[:geometry].split('x'))
        resized = "#{target.width.to_i - padding[1] - padding[3]}x#{target.height.to_i - padding[0] - padding[2]}"
        audio   = AUDIO_PROFILES[options[:audio_profile].to_sym]
        video   = VIDEO_PROFILES[options[:video_profile].to_sym]

        # Two-pass encoding with a target bitrate is a good way to balance file size for streaming
        # with perceptual quality.
        if options[:two_pass]
          cmd = <<-CMD
            ffmpeg -i #{@file.path} -pass 1 -an #{video.sub(/-vpre [a-z]+/, '')} -vpre fastfirstpass
            -s #{resized}
            -f rawvideo -y /dev/null

            &&

            ffmpeg -i #{@file.path} -pass 2 #{audio} #{video}
            -padtop #{padding[0]} -padright #{padding[1]} -padbottom #{padding[2]} -padleft #{padding[3]}
            -s #{resized}
            -f #{options[:format]} -y #{out}
          CMD
        # Single pass encoding can be good enough, and may take less time based on your settings.
        else
          cmd = <<-CMD
            ffmpeg -i #{@file.path} #{audio} #{video}
            -padtop #{padding[0]} -padright #{padding[1]} -padbottom #{padding[2]} -padleft #{padding[3]}
            -s #{resized}
            -f #{options[:format]} -y #{out}
          CMD
        end
      end

      def needs_qt_faststart?
        VIDEO_PROFILES[options[:video_profile].to_sym].include?('libx264')
      end

      def qt_faststart(path)
        cmd = <<-CMD
          qt-faststart #{path} #{path}-$$

          &&

          mv #{path}-$$ #{path}
        CMD
      end
  end
end
