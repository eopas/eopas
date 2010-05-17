class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  helper_method :current_user

  private
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  protected
   protected
   def permission_denied
     if current_user
       flash[:error] = "Sorry, you are not allowed to access that page."
       redirect_to root_url
     else
       store_location
       flash[:error] = "You must be logged in to access that page."
       redirect_to login_path
     end
   end


end
