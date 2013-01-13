class Admin::SetupWizardsController < ApplicationController
  before_filter :check_not_configured
  respond_to :html

  def new
    @user = User.new
  end

  def create
    AppConfig.item_prefix = params[:item_prefix]

    @user = User.new do |user|
      user.first_name            = params[:first_name]
      user.last_name             = params[:last_name]
      user.email                 = params[:email]
      user.password              = params[:user_password]
      user.password_confirmation = params[:password_confirmation]
    end
    @user.add_role(:admin)
    @user.confirm!
    if @user.save
      flash[:notice] = "The site has been set up and the admin user created - please log in."
    end

    AppConfig.setup_completed = true

    respond_with @user, :location => root_url
  end


  private
  def check_not_configured
    if AppConfig.setup_completed
      flash[:error] = 'Application has already been configured'
      redirect_to root_url
    end
    false
  end
end
