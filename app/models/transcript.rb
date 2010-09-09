class ProperSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    transcription = Transcription.new(:data => File.read(value.queued_for_write[:original]), :format => record.transcript_format)
    errors = transcription.validate
    unless errors.empty?
      record.errors[attribute] << "Transcript did not validate against the schema"
      errors.each do |error|
        record.errors[attribute] << error.message
      end
    end
  end
end

class Transcript < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'
  belongs_to :media_item

  has_many :transcript_tiers

  include Paperclip
  has_attached_file :original

  attr_accessible :original, :transcript_format

  FORMATS = ['ELAN', 'Toolbox', 'Transcriber', 'EOPAS']

  validates :original,          :presence => true, :proper_schema => true
  validates :transcript_format, :presence => true, :inclusion => { :in => FORMATS }
  validates :depositor,         :presence => true
  validates :language_code,     :presence => true
  validates :date,              :presence => true

  validates_associated :depositor
  validates_attachment_presence :original

  before_validation :parse_transcript


  def to_s
    "\ntranscript {\n"+
    "   id:         "+self.id.to_s+"\n"+
    "   media_item: "+self.media_item.to_s+"\n"+
    "   depositor:  "+self.depositor.to_s+"\n"+
    "   creator:    "+self.creator.to_s+"\n"+
    "   language:   "+self.language_code.to_s+"\n"+
    "   date:       "+self.date.to_s+"\n"+
    "   original:   "+self.original_file_name.to_s+"\n"+
    "   created:    "+self.created_at.to_s+"\n"+
    "}\n"
  end

  protected
  def parse_transcript
    transcription = Transcription.new(:data => File.read(original.queued_for_write[:original]), :format => transcript_format)
    transcription.import(self)
  end

end


