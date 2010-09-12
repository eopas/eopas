module MediaItemsHelper
  def media_item_video_tag(media_item, options = {}, &block)
    options = {
      :controls => ''
    }.merge(options)

    options[:width] = 320
    options[:height] = 240
    options[:src] = media_item.original.url(:standard)
    options[:poster] = media_item.original.url(:poster)

    if block_given?
      content_tag :video, yield, options
    else
      content_tag 'video', nil, options
    end
  end
end

