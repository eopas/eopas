class MediaItemsController < ApplicationController
  respond_to :html

  filter_access_to :all

  def index
    @media_items = (MediaItem.are_public + current_user.media_items).uniq
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
      @media_item = MediaItem.are_public.find params[:id]
    end

    @transcripts = @media_item.transcripts
  end

  def destroy
    @media_item = current_user.media_items.find params[:id]

    if params[:force] == 'true'
      @media_item.destroy
      flash[:notice] = 'Media Item and transcript links deleted'

      redirect_to media_items_path
    elsif @media_item.transcripts.empty?
      @media_item.destroy
      flash[:notice] = 'Media Item deleted!'

      redirect_to media_items_path
    else
      flash[:error] = "The Media Item is currently linked to by transcript, possibly also by other users, click on 'Force Delete' to really delete it."
      @force_delete = true
      @transcripts = @media_item.transcripts
      render '/media_items/show'
    end
  end



end
