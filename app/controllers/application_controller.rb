class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.admin?
    flash[:alert] = 'You are not authorized to access this resource'
    redirect_to root_path
  end
end
