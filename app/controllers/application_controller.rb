class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_timezone
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  protected
  
  def after_sign_up_path_for(resource)
    root_path
  end

  def after_sign_in_path_for(resource)
  #  if current_user.admin?
  #    admin_root_path
  #  else
      root_path
  #  end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ roles: [] }, :first_name, :last_name, :email, :password, :password_confirmation, :role, :company_name, :ein, 
      :website) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit({ roles: [] }, :first_name, :last_name, :email, :password, :password_confirmation, :timezone, :current_password, :company_name, :ein, 
      :website) }
  end

  private

  def set_timezone
    tz = current_user ? current_user.timezone : nil
    Time.zone = tz || ActiveSupport::TimeZone["London"]
  end
end
