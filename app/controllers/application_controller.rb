class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.json{head :forbidden}
      format.html{redirect_to root_path, alert: t(".flash_warning_user")}
    end
  end
  protect_from_forgery with: :exception
  include SessionsHelper

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(name address))
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "flash_user_not_found"
    redirect_to root_path
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if user_signed_in?
    store_location
    flash[:danger] = t "users.require_loggedin_msg"
    redirect_to login_path
  end

  def admin_user
    return if authorized_admin? current_user
    flash[:danger] = t "flash_warning_user"
    redirect_to root_path
  end
end
