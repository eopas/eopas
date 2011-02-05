class TranscriptWord < ActiveRecord::Base
  belongs_to :phrase, :class_name => 'TranscriptPhrase', :foreign_key => 'transcript_phrase_id'

  has_many :morphemes, :class_name => 'TranscriptMorpheme', :dependent => :destroy

  validates :position,    :presence => true, :numericality => true
  validates :word,        :presence => true
end
