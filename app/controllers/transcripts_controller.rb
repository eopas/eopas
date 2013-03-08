class TranscriptsController < ApplicationController
  respond_to :html, :xml

  filter_access_to :all
  before_filter :terms_agreement, :only => [:index, :show]

  def index
    if params[:commit] == 'Clear'
      params[:search] = ""
    end

    if current_user and current_user.admin?
      @transcripts = Transcript.scoped
    else
      @transcripts = Transcript.current_user_and_public(current_user).search params[:search]
    end

    if params[:language_code]
      @transcripts = @transcripts.where :language_code => params[:language_code]
    end

    # sort by a given column
    if params[:sort] == "media_item"
      @transcripts = @transcripts.sort_by {|a| a.media_item ? a.media_item.title : ""}
    else
      # make sure we got passed a valid column to sort by
      if Transcript.column_names.find_index(params[:sort])
        @transcripts = @transcripts.sort_by {|a| a.send(params[:sort]).to_s}
      else
        @transcripts = @transcripts.sort_by {|a| a.title ? a.title : ""}
      end
    end

    # reverse order if requested
    if params[:direction] == "desc"
      @transcripts = @transcripts.reverse
    end

    # FIXME: pagination
    #@transcripts = @transcripts.per(20).page(params[:page])
  end

  def show
    if current_user and current_user.admin?
      @transcript = Transcript.find params[:id]
    else
      @transcript = Transcript.current_user_and_public(current_user).find params[:id]
    end

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

  def new
    @transcript = Transcript.new
  end

  def create
    @transcript = current_user.transcripts.build params[:transcript]

    options = Hash.new
    if @transcript.save
      flash[:notice] = 'Transcript was successfully validated and added, please edit automatically discovered values'
      options[:location] = edit_transcript_path @transcript
    end

    respond_with @transcript, options
  end

  def edit
    if current_user and current_user.admin?
      @transcript = Transcript.find params[:id]
    else
      @transcript = current_user.transcripts.find params[:id]
    end
    (3 - @transcript.participants.size).times { @transcript.participants.build }
  end

  def update
    if current_user and current_user.admin?
      @transcript = Transcript.find params[:id]
    else
      @transcript = current_user.transcripts.find params[:id]
    end
    if @transcript.update_attributes(params[:transcript])
      flash[:notice] = 'Transcript was successfully updated.'
    end

    respond_with @transcript
  end

  def destroy
    if current_user and current_user.admin?
      @transcript = Transcript.find params[:id]
    else
      @transcript = current_user.transcripts.find params[:id]
    end

    @transcript.destroy
    flash[:notice] = 'Transcript deleted!'

    redirect_to transcripts_path
  end

  filter_access_to :remove_media_item, :require => :delete
  def remove_media_item
    @transcript = current_user.transcripts.find params[:id]
    @transcript.media_item_id = nil
    @transcript.save
    flash[:notice] = 'Media detached!'

    redirect_to @transcript
  end


  filter_access_to :new_attach_media_item, :require => :new
  def new_attach_media_item
    if current_user and current_user.admin?
      @transcript = Transcript.find params[:id]
    else
      @transcript = current_user.transcripts.find params[:id]
    end
    @media_items = MediaItem.current_user_and_public(current_user)
  end

  filter_access_to :create_attach_media_item, :require => :create
  def create_attach_media_item
    if current_user and current_user.admin?
      @transcript = Transcript.find params[:transcript_id]
    else
      @transcript = current_user.transcripts.find params[:transcript_id]
    end

    if current_user and current_user.admin?
      @media_item = MediaItem.find params[:media_item_id]
    else
      @media_item = MediaItem.current_user_and_public(current_user).find params[:media_item_id]
    end

    @transcript.media_item = @media_item

    flash[:notice] = 'Media Item was added to transcript' if @transcript.save

    respond_with @transcript
  end

  private
  def terms_agreement
    return if current_user
    return if session[:agreed_to_terms]

    store_location
    redirect_to show_terms_users_path
  end

end
