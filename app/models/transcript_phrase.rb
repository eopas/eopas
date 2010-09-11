class TranscriptPhrase < ActiveRecord::Base
  belongs_to :transcript_tier

  serialize :words, Array


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