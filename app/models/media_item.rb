require 'paperclip_bug_fixes'
class MediaItem < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'
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
