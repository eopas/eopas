require 'paperclip_bug_fixes'
class MediaItem < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'
  has_one :transcript

  before_save :create_item_id

  include Paperclip
  has_attached_file :original,
    :styles => {
      :standard => {
        :format     => :ogg,
        :geometry   => '320x240',
        :processors => [ :kickvideo_encoder ],
      },
      :poster => {
        :format     => :png,
        :position   => 5,
        :geometry   => '320x240',
        :processors => [ :kickvideo_thumbnailer ],
      },
      :thumbnail => {
        :format     => :png,
        :position   => 5,
        :geometry   => '160x120',
        :processors => [ :kickvideo_thumbnailer ],
      }
    }

  process_in_background :original

  attr_accessible :title, :original, :recorded_at, :annotator_name, :presenter_name, :presenter_role, :language_code,
                  :copyright, :license, :private

  validates_presence_of :title, :depositor, :recorded_at, :language_code, :license
  validates_associated :depositor

  validates_attachment_presence :original
  validates_attached_video :original

  PRESENTER_ROLES = ['speaker', 'singer', 'signer']

  def to_s
    "\nmedia_item {\n"+
    "   id:         "+self.id.to_s+"\n"+
    "   item_id:   "+self.item_id.to_s+"\n"+
    "   title:     "+self.title.to_s+"\n"+
    "   depositor: "+self.depositor.to_s+"\n"+
    "   original:  "+self.original_file_name.to_s+"\n"+
    "   annotator: "+self.annotator_name.to_s+"\n"+
    "   language:  "+self.language_code.to_s+"\n"+
    "   created:   "+self.created_at.to_s+"\n"+
    "}\n"
  end

  protected
  def create_item_id
    prefix = AppConfig.item_prefix || ""
    basename = original_file_name[/^([^.]+)\./, 1]
    id=0
    itemId = prefix+basename+"_"+String(id)
    while MediaItem.find_by_item_id(itemId)
      id+=1
      itemId = prefix+basename+"_"+String(id)
    end
    self.item_id = itemId
  end

end
