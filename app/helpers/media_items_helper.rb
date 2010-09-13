module MediaItemsHelper
  def media_item_video_tag(media_item, options = {}, &block)
    options = {
      :controls => '',
      :width    => 320,
      :height   => 240,
      :src      => media_item.original.url(:standard),
      :poster   => media_item.original.url(:poster)
    }.merge(options)

    if block_given?
      content_tag :video, yield, options
    else
      content_tag 'video', nil, options
    end
  end

  def media_item_embed_tag(media_item, options = {}, &block)
    options = {
      :class       => 'eopas_player',
      :frameborder => 0,
      :type        => 'text/html',
      :width       => '320',
      :height      => '240',
      :src         => 'http://'+request.host+(request.port!=80 ? ':'+request.port.to_s : '') + media_item.original.url(:standard)
    }.merge(options)

    if block_given?
      content_tag :iframe, yield, options
    else
      content_tag 'iframe', nil, options
    end
  end

end

