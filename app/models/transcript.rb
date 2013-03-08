require 'transcription'

class ProperSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.new_record?

    transcription = record.instance_variable_get(:@transcription)
    if transcription.nil?
      record.errors[attribute] = 'Missing transcription'
    else
      errors = transcription.validate
      unless errors.empty?
        record.errors[attribute] << 'Transcript did not validate against the schema'
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

  has_many :phrases, :class_name => 'TranscriptPhrase', :dependent => :destroy
  has_many :participants, :dependent => :destroy

  accepts_nested_attributes_for :participants, :allow_destroy => true, :reject_if => lambda { |participant| participant[:name].blank? }

  accepts_nested_attributes_for :phrases

  # Access AREL so we can do an OR without writing SQL
  scope :current_user_and_public, lambda { |user|
    if user
      where(
        arel_table[:private].eq(false).
        or(arel_table[:depositor_id].eq(user.id))
      )
    else
      where(:private => false)
    end
  }

  mount_uploader :source, TranscriptUploader

  attr_accessible :title, :date, :country_code, :language_code, :copyright, :license, :private, :source, :source_cache, :transcript_format, :participants_attributes, :description

  FORMATS = ['ELAN', 'Toolbox', 'Transcriber', 'EOPAS']

  validates :source,            :presence => true, :integrity => true, :processing => true, :proper_schema => true
  validates :transcript_format, :presence => true, :inclusion => { :in => FORMATS }
  validates :depositor,         :presence => true

  # Validated on second step
  validates :title,             :presence => true, :unless => lambda { new_record? }
  validates :date,              :presence => true, :unless => lambda { new_record? }
  validates :country_code,      :presence => true, :unless => lambda { new_record? }
  validates :language_code,      :presence => true, :unless => lambda { new_record? }

  validates_associated :depositor

  before_validation :create_transcription

  def self.search(search)
    if search
      where(['title LIKE ? OR description LIKE ? OR country_code LIKE ? OR language_code LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
    else
      scoped
    end
  end

  def create_transcription
    file_path = source.file.path
    @transcription = Transcription.new(:data => File.read(file_path).force_encoding('UTF-8'), :format => transcript_format)
    @transcription.import self
  end

end


