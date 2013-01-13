module Kickvideo #:nodoc:
  class ProcessingError < StandardError #:nodoc:
  end
end

module Paperclip::ClassMethods
  # Validates that the named Paperclip file is a video by using the RVideo::Inspector. This in turn
  # uses `FFMPEG -i` to discover video streams. If no video stream is found, it's not a video. Easy.
  # 
  # I recommend only validating on create. Otherwise this could retrieve the file from S3 every time you update the record.
  def validates_attached_video(name, options = {})
    validates_each(:"#{name}_content_type", options) do |record, attr, value|
      file = record.send(name).queued_for_write[:original]
      unless file.nil? or Kickvideo::Inspector.new(:file => file.path).video?
        record.errors.add(:"#{name}_content_type", :invalid, :default => options[:message], :value => value)
      end
    end
  end

  def validates_attached_audio(name, options = {})
    validates_each(:"#{name}_content_type", options) do |record, attr, value|
      file = record.send(name).queued_for_write[:original]
      unless file.nil? or Kickvideo::Inspector.new(:file => file.path).audio?
        record.errors.add(:"#{name}_content_type", :invalid, :default => options[:message], :value => value)
      end
    end
  end

  def validates_attached_media(name, options = {})
    validates_each(:"#{name}_content_type", options) do |record, attr, value|
      file = record.send(name).queued_for_write[:original]
      unless file.nil? or Kickvideo::Inspector.new(:file => file.path).video? or  Kickvideo::Inspector.new(:file => file.path).audio?
        record.errors.add(:"#{name}_content_type", :invalid, :default => options[:message], :value => value)
      end
    end
  end

end

