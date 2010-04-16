class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default current_user
    else
      render :action => :new
    end
  end

  def destroy
    if current_user
      current_user_session.destroy
      flash[:notice] = "Logout successful!"
    else
      flash[:error] = "You are already logged out!"
    end

    redirect_back_or_default root_url
  end
end

