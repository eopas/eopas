require 'transcription'

class ProperSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    errors = record.instance_variable_get(:@transcription).validate
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

  has_many :tiers, :class_name => 'TranscriptTier', :dependent => :destroy

  include Paperclip
  has_attached_file :original

  attr_accessible :original, :transcript_format

  FORMATS = ['ELAN', 'Toolbox', 'Transcriber', 'EOPAS']

  validates :original,          :presence => true, :proper_schema => true
  validates :transcript_format, :presence => true, :inclusion => { :in => FORMATS }
  validates :depositor,         :presence => true

  validates_associated :depositor
  validates_attachment_presence :original

  before_validation :create_transcription
  before_save :import_transcription


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
  def create_transcription
    # WTF: For some reason if this isn't an instance variable
    @file_jf = original.queued_for_write[:original]
    # TODO Can we just force the encoding here or should we try and detect it?
    @transcription = Transcription.new(:data => File.read(@file_jf.path).force_encoding('UTF-8'), :format => transcript_format)
  end

  def import_transcription
    @transcription.import(self)
  end

end


