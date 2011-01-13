require 'transcription'

class ProperSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.tiers.empty?
      return
    end
    transcription = record.instance_variable_get(:@transcription)
    if transcription.nil?
      record.errors[attribute] = 'Missing transcription'
    else
      errors = transcription.validate
      unless errors.empty?
        record.errors[attribute] << "Transcript did not validate against the schema"
        errors.each do |error|
          record.errors[attribute] << error.message
        end
      end
    end
  end
end

class Transcript < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'
  belongs_to :media_item

  has_many :tiers, :class_name => 'TranscriptTier', :dependent => :destroy

  scope :are_private, where(:private => true)
  scope :are_public, where(:private => false)

  include Paperclip
  has_attached_file :original, :url => "/system/transcript/:attachment/:id/:style/:filename"

  attr_accessible :original, :transcript_format, :title

  attr_accessor :country_code # So on validation errror it is still filled in

  FORMATS = ['ELAN', 'Toolbox', 'Transcriber', 'EOPAS']

  validates :original,          :presence => true, :proper_schema => true
  validates :transcript_format, :presence => true, :inclusion => { :in => FORMATS }
  validates :depositor,         :presence => true

  # Validated on second step
  validates :title,             :presence => true, :unless => lambda { new_record? }

  validates_associated :depositor
  validates_attachment_presence :original

  before_validation :create_transcription, :on => :create
  before_save :import_transcription, :on => :create


  def to_s
    "\ntranscript {\n"+
    "   id:         "+self.id.to_s+"\n"+
    "   title:      "+self.title.to_s+"\n"+
    "   media_item: "+self.media_item.to_s+"\n"+
    "   depositor:  "+self.depositor.to_s+"\n"+
    "   creator:    "+self.creator.to_s+"\n"+
    "   language:   "+self.language_code.to_s+"\n"+
    "   date:       "+self.date.to_s+"\n"+
    "   original:   "+self.original_file_name.to_s+"\n"+
    "   created:    "+self.created_at.to_s+"\n"+
    "}\n"
  end

  def self.search(search)
    if search
      where(['title LIKE ?', "%#{search}%"])
    else
      scoped
    end
  end

  protected
  def create_transcription
    # FIXME find a better way of doing this
    if original_file_name
      file_path = original.to_file.path
      @transcription = Transcription.new(:data => File.read(file_path).force_encoding('UTF-8'), :format => transcript_format)
    end
  end

  def import_transcription
    if @transcription
      @transcription.import self
    end
  end

end


