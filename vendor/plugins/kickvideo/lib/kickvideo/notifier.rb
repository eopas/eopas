class Kickvideo::Notifier < ActionMailer::Base
  self.mailer_name = 'kickvideo_notifier'
  self.view_paths << "#{File.dirname(__FILE__)}/../../app/views"
  
  cattr_accessor :sender_address
  @@sender_address ||= "Kickvideo <kickvideo-errors@default.com>"
  @@sender_address = ExceptionNotifier.sender_address if defined? ExceptionNotifier
  
  cattr_accessor :exception_recipients
  @@exception_recipients = []
  @@exception_recipients = ExceptionNotifier.exception_recipients if defined? ExceptionNotifier

  def processing_error(record, attachment, command, output)
    from       self.class.sender_address
    recipients self.class.exception_recipients
    subject    "[KICKVIDEO] Processing error on #{record.class}##{record.id} #{attachment.name}"
    body       :record => record, :attachment => attachment, :command => command, :output => output
  end
end
