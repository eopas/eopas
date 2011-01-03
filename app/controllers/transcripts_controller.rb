class TranscriptsController < ApplicationController
  respond_to :xml, :html

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

    # TODO we should probably only do this for xml
    # TODO Pick some better filename dynamically
    headers["Content-Disposition"] = "attachment; filename=\"eopas.xml\""

    respond_with @transcript
  end

  def destroy
    @transcript = current_user.transcripts.find params[:id]

    @transcript.destroy
    flash[:notice] = 'Transcript deleted!'

    redirect_to transcripts_path
  end
end
