class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private 

  def not_authenticated
    redirect_to main_app.login_path
  end
end
