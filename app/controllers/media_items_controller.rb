class MediaItemsController < ApplicationController
  respond_to :html

  filter_access_to :all

  def index
    @media_items = MediaItem.public_items + current_user.media_items
    @media_items.uniq
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
    begin
      @media_item = current_user.media_items.find params[:id]
    rescue ActiveRecord::RecordNotFound
      @media_item = MediaItem.public_items.find params[:id]
    end

    @transcripts = @media_item.transcripts
  end

end
