class MediaItemsController < ApplicationController
  respond_to :html

  filter_access_to :all

  def index
    @media_items = MediaItem.all
  end

  def new
    @media_item = MediaItem.new(
      :presenter_role => "speaker",
      :license        => "CC-AU-BY-SA",
      :language_code  => "en",
      :private        => false,
    )
  end

  def create
    @media_item = current_user.media_items.build params[:media_item]

    if @media_item.save
      flash[:notice] = 'Media item was successfully created.'
    end

    respond_with @media_item
  end

  def show
    @media_item = current_user.media_items.find params[:id]
  end

end
