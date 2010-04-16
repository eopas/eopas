class UsersController < ApplicationController
  respond_to :html

  #filter_access_to :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = "Thanks for signing up. Please check your email to confirm your account.."
      UserMailer.registration_confirmation(@user).deliver
    end

    respond_with @user, :location => root_url
  end

  def confirm
    @user = User.find_by_perishable_token(params[:id])
    unless @user
      flash[:error] = "We're sorry, that account confirmation token is not valid."
      redirect_to root_url && return
    end

    @user.confirm!
    if @user.save
      UserSession.create(@user)
      flash[:notice] = 'Your account has been activated and you have been logged in.'
      redirect_to @user
    else
      flash[:error] = 'Activation of your account failed.'
      redirect_to root_url
    end
  end

  def show
    if current_user.id != params[:id].to_i
      raise ActiveRecord::RecordNotFound
    end
    @user = current_user
  end


end

