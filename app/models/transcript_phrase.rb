class TranscriptPhrase < ActiveRecord::Base
  belongs_to :tier, :class_name => 'TranscriptTier', :foreign_key => :transcript_tier_id

  serialize :words, Array

  # Here we are only setting up search for individual words or morphemes for clickability in a transcript
#  searchable do
#    text :text
#    text :morphemes do |phrase|
#      phrase.words.each do |word|
#        if word[:morphemes]['morpheme']
#          m = word[:morphemes]['morpheme'].join(' ')
#          puts m
#          m
#        end
#      end
#    end
#  end

  def to_s
    "\ntranscript_phrase {\n"+
    "   id:              "+self.id.to_s+"\n"+
    "   transcript_tier: "+self.transcript_tier.to_s+"\n"+
    "   phrase_id:       "+self.phrase_id.to_s+"\n"+
    "   start_time:      "+self.start_time.to_s+"\n"+
    "   end_time:        "+self.end_time.to_s+"\n"+
    "   text:            "+self.text.to_s+"\n"+
    "   participant:     "+self.participant.to_s+"\n"+
    "   ref_phrase:      "+self.ref_phrase.to_s+"\n"+
    "}\n"
  end
end
