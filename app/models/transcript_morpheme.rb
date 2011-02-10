class TranscriptMorpheme < ActiveRecord::Base
  belongs_to :word, :class_name => 'TranscriptWord', :foreign_key => :transcript_word_id

  default_scope order(:position)

  validates :position, :presence => true, :numericality => true
end
