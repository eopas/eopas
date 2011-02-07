class TranscriptPhrase < ActiveRecord::Base
  belongs_to :transcript

  has_many :words, :class_name => 'TranscriptWord', :dependent => :destroy

  accepts_nested_attributes_for :words

  validates :start_time,  :presence => true, :numericality => true
  validates :end_time,    :presence => true, :numericality => true
  validates :phrase_id,   :presence => true
  validates :original,    :presence => true, :length => {:maximum => 4096}
  validates :translation, :length => {:maximum => 4096}

end
