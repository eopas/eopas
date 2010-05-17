class MediaItem < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'

  attr_accessible :title

  validates_presence_of :title, :depositor
  validates_associated :depositor
end
