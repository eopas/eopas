module Kickvideo
  class Processor < ::Paperclip::Processor #:nodoc:
    protected

      # A more opinionated version of Paperclip::Run. Captures all output, including stderr,
      # and raise an error 
      def run(cmd)
        output = `#{cmd.gsub(/\s+/, " ")} 2>&1`

        unless $?.exitstatus == 0
          #Kickvideo::Notifier.deliver_processing_error(@attachment.instance, @attachment, cmd, output)
          raise Kickvideo::ProcessingError, "Error while running #{cmd} - #{output}"
        end
        
        output
      end

      def inspector
        @inspector ||= Kickvideo::Inspector.new(:file => @file.path)
      end
  end
end
