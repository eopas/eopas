class Admin::SetupWizardsController < ApplicationController
  before_filter :check_not_configured
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(params)

    @user.add_role(:admin)
    @user.confirm!

    if @user.save
      flash[:notice] = "Log in as the admin user"
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
