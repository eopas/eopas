class MediaItem < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'
  has_many :transcripts, :dependent => :nullify

  # Access AREL so we can do an OR without writing SQL
  scope :current_user_and_public, lambda { |user|
    if user
      where(
        arel_table[:private].eq(false).
        or(arel_table[:depositor_id].eq(user.id))
      )
    else
      where(:private => false)
    end
  }

  mount_uploader :media, MediaUploader
  process_in_background :media

  attr_accessible :title, :description, :recorded_on, :copyright, :license, :private, :format, :media, :media_cache

  FORMATS = %w{audio video}

  validates :format, :presence => true, :inclusion => { :in => FORMATS }

  validates :title,       :presence => true
  validates :depositor,   :presence => true, :associated => true
  validates :recorded_on, :presence => true
  validates :copyright,   :presence => true
  validates :license,     :presence => true
  validates :media,       :presence => true, :integrity => true, :processing => true
end
