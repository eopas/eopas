class StaticController < ApplicationController

  def home
    puts AppConfig.setup_completed
    unless AppConfig.setup_completed
      redirect_to new_admin_setup_wizard_path
    end
  end

end
