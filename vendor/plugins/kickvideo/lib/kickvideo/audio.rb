module Kickvideo #:nodoc:
  class Audio < Processor
    AUDIO_PROFILES = {
      # Default should work with any install.
      :default => "-ar 22050 -ab 64k -async 2 -acodec libvorbis",
      # Ogg codec.
      :ogg => "-ar 22050 -ab 64k -async 2 -acodec libvorbis",
      # MP3 codec. Should also be pretty safe.
      :mp3     => "-ar 22050 -ab 64k -async 2 -acodec libmp3lame",
      # AAC requires a lib that may not be available by default.
      :aac     => "-ar 22050 -ab 64k -async 2 -acodec libfaac"
    }

    # Processor options are:
    # * +audio_profile+: Which Paperclip::KickvideoEncoder::AUDIO_PROFILES to use.
    # * +format+: What container (and therefore extension) to use for the file. Defaults to MP4.
    def initialize(*args, &block)
      super
      options[:audio_profile] ||= :default
      options[:format]        ||= :ogg
    end

    def make
      return unless inspector.audio?

      Paperclip::Tempfile.new(@file.path + '-encoded').tap do |dst|
        dst.binmode
        run ffmpeg_command(dst.path)
      end
    end

    protected

      def ffmpeg_command(out)
        audio   = AUDIO_PROFILES[options[:audio_profile].to_sym]

        cmd = <<-CMD
          ffmpeg -i #{@file.path} #{audio}
          -f #{options[:format]} -y #{out}
        CMD
      end

  end
end
