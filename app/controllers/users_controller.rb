class UsersController < ApplicationController
  respond_to :html

  filter_access_to :show

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
    @user.add_role(:user)
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

  def edit
    if current_user.id != params[:id].to_i
      raise ActiveRecord::RecordNotFound
    end
    @user = current_user
  end

  def update
    if current_user.id != params[:id].to_i
      raise ActiveRecord::RecordNotFound
    end
    user = params[:user]
    @user = current_user
    details_changed = false
    password_changed = false
    if (@user.first_name != user[:first_name] ||
        @user.last_name  != user[:last_name]  ||
        @user.email      != user[:email])
      @user.first_name = user[:first_name]
      @user.last_name  = user[:last_name]
      @user.email      = user[:email]
      details_changed  = true
    end
    if (user[:password] == user[:password_confirmation])
      @user.password              = user[:password]
      @user.password_confirmation = user[:password_confirmation]
      password_changed = true
    end
    if (details_changed || password_changed)
      if @user.save
        if (password_changed)
          flash[:notice] = 'Your account details have been updated, including password.'
        else
          flash[:notice] = 'Your account details have been updated.'
        end
        redirect_to @user
      else
        flash[:error] = 'Error updating account.'
        @user = current_user
        render :action => :edit
      end
    else
      flash[:notice] = 'Your account details have not changed.'
      render :action => :edit
    end
  end

  def show_terms
  end

  def agree_to_terms
    if params[:agree]
      session[:agreed_to_terms] = true
      redirect_back_or_default root_path
    else
      flash[:error] = 'You must agree to the terms before you can view transcripts without a login'
      redirect_to show_terms_users_path
    end
  end
end

