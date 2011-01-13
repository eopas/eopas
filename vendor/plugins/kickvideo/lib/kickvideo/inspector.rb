module Kickvideo
  # Yes, this is a shameless grab from RVideo::Inspector. The issue is that RVideo is not being
  # maintained, and is incompatible with the latest version of FFMPEG. So I don't want Kickvideo
  # to depend on it. When RVideo is updated again, I will accept it as a dependency.
  class Inspector #:nodoc:

    attr_reader :filename, :path, :full_filename, :raw_response, :raw_metadata

    attr_accessor :ffmpeg_binary

    #
    # To inspect a video or audio file, initialize an Inspector object.
    #
    #   file = RVideo::Inspector.new(options_hash)
    #
    # Inspector accepts three options: file, raw_response, and ffmpeg_binary.
    # Either raw_response or file is required; ffmpeg binary is optional.
    #
    # :file is a path to a file to be inspected.
    #
    # :raw_response is the full output of "ffmpeg -i [file]". If the
    # :raw_response option is used, RVideo will not actually inspect a file;
    # it will simply parse the provided response. This is useful if your
    # application has already collected the ffmpeg -i response, and you don't
    # want to call it again.
    #
    # :ffmpeg_binary is an optional argument that specifies the path to the
    # ffmpeg binary to be used. If a path is not explicitly declared, RVideo
    # will assume that ffmpeg exists in the Unix path. Type "which ffmpeg" to
    # check if ffmpeg is installed and exists in your operating system's path.
    #

    def initialize(options = {})
      if options[:raw_response]
        @raw_response = options[:raw_response]
      elsif options[:file]
        if options[:ffmpeg_binary]
          @ffmpeg_binary = options[:ffmpeg_binary]
          raise RuntimeError, "ffmpeg could not be found (trying #{@ffmpeg_binary})" unless FileTest.exist?(@ffmpeg_binary)
        else
          # assume it is in the unix path
          raise RuntimeError, 'ffmpeg could not be found (expected ffmpeg to be found in the Unix path)' unless FileTest.exist?(`which ffmpeg`.chomp)
          @ffmpeg_binary = "ffmpeg"
        end

        file = options[:file]
        @filename = File.basename(file)
        @path = File.dirname(file)
        @full_filename = file
        raise ArgumentError, "File not found (#{file})" unless FileTest.exist?(file.gsub("\"",""))
        @raw_response = `#{@ffmpeg_binary} -i "#{@full_filename}" 2>&1`
      else
        raise ArgumentError, "Must supply either an input file or a pregenerated response" if options[:raw_response].nil? and file.nil?
      end

      metadata = /(Input \#.*)\n(Must|At\sleast)/m.match(@raw_response)

      if /Unknown format/i.match(@raw_response) || metadata.nil?
        @unknown_format = true
      elsif /Duration: N\/A|bitrate: N\/A/im.match(@raw_response)
        @unreadable_file = true
        @raw_metadata = metadata[1] # in this case, we can at least still get the container type
      else
        @raw_metadata = metadata[1]
      end
    end

    #
    # Returns true if the file can be read successfully. Returns false otherwise.
    #

    def valid?
      if unknown_format? #or unreadable_file?
        false
      else
        true
      end
    end

    #
    # Returns false if the file can be read successfully. Returns false otherwise.
    #

    def invalid?
      !valid?
    end

    #
    # True if the format is not understood ("Unknown Format")
    #

    def unknown_format?
      if @unknown_format
        true
      else
        false
      end
    end

    #
    # True if the file is not readable ("Duration: N/A, bitrate: N/A")
    #

    def unreadable_file?
      if @unreadable_file
        true
      else
        false
      end
    end

    #
    # Does the file have an audio stream?
    #

    def audio?
      if audio_match.nil?
        false
      else
        true
      end
    end

    #
    # Does the file have a video stream?
    #

    def video?
      if video_match.nil?
        false
      else
        true
      end
    end


    #
    # Returns the version of ffmpeg used, In practice, this may or may not be
    # useful.
    #
    # Examples:
    #
    #   SVN-r6399
    #   CVS
    #

    def ffmpeg_version
      @ffmpeg_version = @raw_response.split("\n").first.split("version").last.split(",").first.strip
    end

    #
    # Returns the configuration options used to build ffmpeg.
    #
    # Example:
    #
    #   --enable-mp3lame --enable-gpl --disable-ffplay --disable-ffserver
    #     --enable-a52 --enable-xvid
    #

    def ffmpeg_configuration
      /(\s*configuration:)(.*)\n/.match(@raw_response)[2].strip
    end

    #
    # Returns the versions of libavutil, libavcodec, and libavformat used by
    # ffmpeg.
    #
    # Example:
    #
    #   libavutil version: 49.0.0
    #   libavcodec version: 51.9.0
    #   libavformat version: 50.4.0
    #

    def ffmpeg_libav
      /^(\s*lib.*\n)+/.match(@raw_response)[0].split("\n").each {|l| l.strip! }
    end

    #
    # Returns the build description for ffmpeg.
    #
    # Example:
    #
    #   built on Apr 15 2006 04:58:19, gcc: 4.0.1 (Apple Computer, Inc. build
    #     5250)
    #

    def ffmpeg_build
      /(\n\s*)(built on.*)(\n)/.match(@raw_response)[2]
    end

    #
    # Returns the container format for the file. Instead of returning a single
    # format, this may return a string of related formats.
    #
    # Examples:
    #
    #   "avi"
    #
    #   "mov,mp4,m4a,3gp,3g2,mj2"
    #

    def container
      return nil if @unknown_format

      /Input \#\d+\,\s*(\S+),\s*from/.match(@raw_metadata)[1]
    end

    #
    # The duration of the movie, as a string.
    #
    # Example:
    #
    #   "00:00:24.4"  # 24.4 seconds
    #
    def raw_duration
      return nil unless valid?

      /Duration:\s*([0-9\:\.]+),/.match(@raw_metadata)[1]
    end

    #
    # The duration of the movie in milliseconds, as an integer.
    #
    # Example:
    #
    #   24400         # 24.4 seconds
    #
    # Note that the precision of the duration is in tenths of a second, not
    # thousandths, but milliseconds are a more standard unit of time than
    # deciseconds.
    #

    def duration
      return nil unless valid?

      units = raw_duration.split(":")
      (units[0].to_i * 60 * 60 * 1000) + (units[1].to_i * 60 * 1000) + (units[2].to_f * 1000).to_i
    end

    #
    # The bitrate of the movie.
    #
    # Example:
    #
    #  3132
    #

    def bitrate
      return nil unless valid?

      bitrate_match[1].to_i
    end

    #
    # The bitrate units used. In practice, this may always be kb/s.
    #
    # Example:
    #
    #   "kb/s"
    #

    def bitrate_units
      return nil unless valid?

      bitrate_match[2]
    end

    def audio_bitrate # :nodoc:
      nil
    end

    def audio_stream
      return nil unless valid?

      #/\n\s*Stream.*Audio:.*\n/.match(@raw_response)[0].strip
      match = /\n\s*Stream.*Audio:.*\n/.match(@raw_response)
      return match[0].strip if match
    end

    #
    # The audio codec used.
    #
    # Example:
    #
    #   "aac"
    #

    def audio_codec
      return nil unless audio?

      audio_match[2]
    end

    #
    # The sampling rate of the audio stream.
    #
    # Example:
    #
    #   44100
    #

    def audio_sample_rate
      return nil unless audio?

      audio_match[3].to_i
    end

    #
    # The units used for the sampling rate. May always be Hz.
    #
    # Example:
    #
    #   "Hz"
    #

    def audio_sample_units
      return nil unless audio?

      audio_match[4]
    end

    #
    # The channels used in the audio stream.
    #
    # Examples:
    #   "stereo"
    #   "mono"
    #   "5:1"
    #

    def audio_channels_string
      return nil unless audio?

      audio_match[5]
    end

    def audio_channels
      return nil unless audio?

      case audio_match[5]
      when "mono"
        1
      when "stereo"
        2
      else
        raise RuntimeError, "Unknown number of channels: #{audio_channels}"
      end
    end

    #
    # The ID of the audio stream (useful for troubleshooting).
    #
    # Example:
    #   #0.1
    #

    def audio_stream_id
      return nil unless audio?

      audio_match[1]
    end

    def video_stream
      return nil unless valid?

      match = /\n\s*Stream.*Video:.*\n/.match(@raw_response)
      return match[0].strip unless match.nil?
      nil
    end

    #
    # The ID of the video stream (useful for troubleshooting).
    #
    # Example:
    #   #0.0
    #

    def video_stream_id
      return nil unless video?

      video_match[1]
    end

    #
    # The video codec used.
    #
    # Example:
    #
    #   "mpeg4"
    #

    def video_codec
      return nil unless video?

      video_match[2]
    end

    #
    # The colorspace of the video stream.
    #
    # Example:
    #
    #   "yuv420p"
    #

    def video_colorspace
      return nil unless video?

      video_match[3]
    end

    #
    # The width of the video in pixels.
    #

    def width
      return nil unless video?

      video_match[4].to_i
    end

    #
    # The height of the video in pixels.
    #

    def height
      return nil unless video?

      video_match[5].to_i
    end

    #
    # width x height, as a string.
    #
    # Examples:
    #   320x240
    #   1280x720
    #

    def resolution
      return nil unless video?

      "#{width}x#{height}"
    end

    #
    # The frame rate of the video in frames per second
    #
    # Example:
    #
    #   "29.97"
    #

    def fps
      return nil unless video?

      /([0-9\.]+) fps/.match(video_stream)[1]
    end

    private

    def bitrate_match
      /bitrate: ([0-9\.]+)\s*(.*)\s+/.match(@raw_metadata)
    end

    def audio_match
      return nil unless valid?

      /Stream\s*(.*?)[,|:|\(|\[].*?\s*Audio:\s*(.*?),\s*([0-9\.]*) (\w*),\s*([a-zA-Z:]*)/.match(audio_stream)
    end

    def video_match
      return nil unless valid?

      match = /Stream\s*(.*?)[,|:|\(|\[].*?\s*Video:\s*(.*?),\s*(.*?),\s*(\d*)x(\d*)/.match(video_stream)

      # work-around for Apple Intermediate format, which does not have a color space
      # I fake up a match data object (yea, duck typing!) with an empty spot where
      # the color space would be.
      if match.nil?
        match = /Stream\s*(.*?)[,|:|\(|\[].*?\s*Video:\s*(.*?),\s*(\d*)x(\d*)/.match(video_stream)
        match = [nil, match[1], match[2], nil, match[3], match[4]] unless match.nil?
      end

      match
    end
  end
end

