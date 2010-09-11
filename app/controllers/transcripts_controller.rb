class TranscriptsController < ApplicationController
  respond_to :xml, :html

  def new
    @media_item = current_user.media_items.find(params[:media_item_id])
    @transcript = @media_item.build_transcript
  end

  def create
    @media_item = current_user.media_items.find(params[:media_item_id])
    @transcript = @media_item.build_transcript params[:transcript]

    @transcript.depositor = current_user

    if @transcript.save
      flash[:notice] = 'Transcript was successfully added'
      respond_with @media_item
    else
      respond_with @transcript
    end

  end

  def show
    # FIXME only show users transcripts SECURITY HOLE
    @transcript = Transcript.find params[:id]

    # TODO Use something from the object to generate the filename
    headers["Content-Disposition"] = "attachment; filename=\"eopas.xml\""
    respond_with @transcript
  end

  def destroy
    @transcript = Transcript.find params[:id]
    media_item = @transcript.media_item

    # FIXME only destroy users transcripts SECURITY HOLE
    @model_class_name = Transcript.find params[:id]
    @model_class_name.destroy
    flash[:notice] = 'Transcript deleted!'

    redirect_to media_item
  end
end
