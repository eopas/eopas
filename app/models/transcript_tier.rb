class TranscriptTier < ActiveRecord::Base
  belongs_to :transcript

  has_one  :parent, :class_name => :transcript_tier
  has_many :phrases, :class_name => 'TranscriptPhrase', :dependent => :destroy

  def to_s
    "\ntranscript_tier {\n"+
    "   id:              "+self.id.to_s+"\n"+
    "   transcript:      "+self.transcript.to_s+"\n"+
    "   parent_id:       "+self.parent_id.to_s+"\n"+
    "   tier_id:         "+self.tier_id.to_s+"\n"+
    "   language:        "+self.language_code.to_s+"\n"+
    "   linguistic_type: "+self.linguistic_type.to_s+"\n"+
    "}\n"
  end
end
