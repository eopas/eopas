module MediaItemsHelper
  def media_item_video_tag(media_item, options = {}, &block)
    options = {
      :controls => '',
      :width    => 320,
      :height   => 240,
      :src      => media_item.media.video.url,
      :poster   => media_item.media.poster.url,
    }.merge(options)

    if block_given?
      content_tag :video, yield, options
    else
      content_tag 'video', nil, options
    end
  end

  def media_item_audio_tag(media_item, options = {}, &block)
    options = {
      :controls => '',
      :src      => media_item.media.audio.url,
    }.merge(options)

    if block_given?
      content_tag :audio, yield, options
    else
      content_tag 'audio', nil, options
    end
  end

  def media_item_embed_tag(media_item, options = {}, &block)
    if media_item.format == 'video'
      item_url = media_item.media.video.url
    else
      item_url = media_item.media.audio.url
    end
    options = {
      :class       => 'eopas_player',
      :frameborder => 0,
      :type        => 'text/html',
      :width       => '320',
      :height      => '240',
      :src         => 'http://'+request.host+(request.port!=80 ? ':'+request.port.to_s : '') + item_url
    }.merge(options)

    if block_given?
      content_tag :iframe, yield, options
    else
      content_tag 'iframe', nil, options
    end
  end

  def media_item_thumb_tag(media_item, options = {})
    if media_item.format == 'video'
      image_tag media_item.media.thumb.url, options
    else
      image_tag '/originals/thumbnail/audio.png', options
    end
  end

end

