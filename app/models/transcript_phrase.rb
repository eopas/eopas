class TranscriptPhrase < ActiveRecord::Base
  belongs_to :transcript

  has_many :words, :class_name => 'TranscriptWord', :dependent => :destroy

  validates :start_time,  :presence => true, :numericality => true
  validates :end_time,    :presence => true, :numericality => true
  validates :phrase_id,   :presence => true
  validates :original,    :presence => true
  validates :translation, :presence => true

end
