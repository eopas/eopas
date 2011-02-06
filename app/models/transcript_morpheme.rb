class TranscriptMorpheme < ActiveRecord::Base
  belongs_to :word, :class_name => :transcript_word

  validates :position, :presence => true, :numericality => true
end
