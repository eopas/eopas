class MediaItem < ActiveRecord::Base
  belongs_to :depositor, :class_name => 'User'

  include Paperclip
  has_attached_file :original

  attr_accessible :title, :original

  validates_presence_of :title, :depositor
  validates_associated :depositor

  validates_attachment_presence :original
end
