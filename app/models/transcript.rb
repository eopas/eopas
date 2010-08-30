class Transcript < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'
  belongs_to :media_item

  has_many :transcript_tiers


  def to_s
    "\ntranscript {\n"+
    "   id:         "+self.id.to_s+"\n"+
    "   media_item: "+self.media_item.to_s+"\n"+
    "   depositor:  "+self.depositor.to_s+"\n"+
    "   creator:    "+self.creator.to_s+"\n"+
    "   title:      "+self.title.to_s+"\n"+
    "   language:   "+self.language_code.to_s+"\n"+
    "   date:       "+self.date.to_s+"\n"+
    "   original:   "+self.original_file_name.to_s+"\n"+
    "   created:    "+self.created_at.to_s+"\n"+
    "}\n"
  end
end