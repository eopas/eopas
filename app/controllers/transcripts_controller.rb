class TranscriptsController < ApplicationController
  respond_to :html, :xml

  filter_access_to :all

  def index
    @transcripts = current_user.transcripts
  end

  def new
    @transcript = Transcript.new
  end

  def create
    @transcript = current_user.transcripts.build params[:transcript]

    flash[:notice] = 'Transcript was successfully added' if @transcript.save

    respond_with @transcript
  end

  def show
    @transcript = current_user.transcripts.find params[:id]
    @media_item = @transcript.media_item

    # TODO Pick some better filename dynamically
    respond_with @transcript do |format|
      format.html { @transcript }
      format.xml do
        headers["Content-Disposition"] = "attachment; filename=\"eopas.xml\""
        @transcript
      end
    end
  end

  def destroy
    @transcript = current_user.transcripts.find params[:id]

    @transcript.destroy
    flash[:notice] = 'Transcript deleted!'

    redirect_to transcripts_path
  end

  filter_access_to :new_attach_media_item, :require => :new
  def new_attach_media_item
    @transcript = current_user.transcripts.find params[:id]
    @media_items = (MediaItem.public_items + current_user.media_items).uniq
  end

  filter_access_to :create_attach_media_item, :require => :create
  def create_attach_media_item
    @transcript = current_user.transcripts.find params[:transcript_id]
    begin
      @media_item = current_user.media_items.find params[:media_item_id]
    rescue ActiveRecord::RecordNotFound
      @media_item = MediaItem.public_items.find params[:media_item_id]
    end

    @transcript.media_item = @media_item

    flash[:notice] = 'Media Item was added to transcript' if @transcript.save

    respond_with @transcript
  end

end
