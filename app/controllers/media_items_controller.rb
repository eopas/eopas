class MediaItemsController < ApplicationController
  respond_to :html

  filter_access_to :all

  def index
    @media_items = (MediaItem.are_public + current_user.media_items).uniq
  end

  def new
    @media_item = MediaItem.new(
      :title            => "EOPAS media",
      :license          => "CC-AU-BY-SA",
      :copyright        => current_user.full_name,
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

  def edit
    @media_item = MediaItem.find params[:id]
  end

  def update
    @media_item = MediaItem.find params[:id]
    if @media_item.update_attributes(params[:media_item])
      flash[:notice] = 'Media item was successfully updated.'
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
