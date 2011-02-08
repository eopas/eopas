class TranscriptMorpheme < ActiveRecord::Base
  belongs_to :word, :class_name => :transcript_word

  default_scope order(:position)

  validates :position, :presence => true, :numericality => true
end
