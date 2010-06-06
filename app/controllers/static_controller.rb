class StaticController < ApplicationController

  def home
    unless AppConfig.setup_completed
      redirect_to new_admin_setup_wizard_path
    end
  end

end
