require 'carrierwave/processing/mime_types'

class MediaUploader < CarrierWave::Uploader::Base

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper
  include CarrierWave::MimeTypes
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer
  include CarrierWave::Backgrounder::Delay

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    asset_path('fallback/' + [version_name, 'default.png'].compact.join('_'))
  end

  process :set_content_type

  version :video, :if => :is_video? do
    process :encode_video => [ :ogv, :resolution => '320x400', :logger => :logger ]
  end
  version :thumb, :if => :is_video? do
    process :thumbnail => [ :format => 'png', :size => 160 ]
  end
  version :poster, :if => :is_video? do
    process :thumbnail => [ :format => 'png', :size => 320 ]
  end
  version :audio, :if => :is_audio? do
    process :encode_video => [ :ogg, :custom => '-acodec libvorbis', :logger => :logger ]
  end
  version :thumb, :if => :is_audio? do
  end

  protected

  def logger
    Rails.logger
  end

  def is_audio?(media)
    model.format == 'audio'
  end

  def is_video?(media)
    model.format == 'video'
  end
end
