class ForgottenPasswordsController < ApplicationController
  respond_to :html

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      UserMailer.forgotten_password(@user).deliver
      flash[:notice] = "Instructions to reset your password have been emailed to you. Please check your email."
    else
      flash[:notice] = "No user was found with that email address"
    end

    respond_with @user, :location => root_url
  end

  def edit
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. Try pasting the URL from your email into your browser."
      redirect_to root_url
    end
  end

  def update
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. Try pasting the URL from your email into your browser."
      redirect_to root_url and return
    end

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    flash[:notice] = 'Password successfully updated' if @user.save

    respond_with @user, :location => @user
  end

end

