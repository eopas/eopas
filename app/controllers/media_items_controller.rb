class MediaItemsController < ApplicationController
  respond_to :html

  filter_access_to :all

  def index
    @media_items = MediaItem.all
  end

  def new
    @media_item = MediaItem.new(
      :participant_role => "speaker",
      :license          => "CC-AU-BY-SA",
      :country_code     => "AU",
      :language_code    => "eng",
      :private          => false,
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
    @media_item = MediaItem.find(params[:id])
    @transcript = @media_item.transcript

    # TODO: JF add a named scope
    if (@media_item.private == true && current_user != @media_item.depositor)
      flash[:notice] = 'You are not allowed to access this content.'
      redirect_back_or_default root_url
    end
  end

end
