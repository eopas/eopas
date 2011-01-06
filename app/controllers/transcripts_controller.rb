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
end
