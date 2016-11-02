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
    case resource
    when Vendor
      edit_vendor_registration_path
    when User
      root_url
    end
  end

  def after_sign_in_path_for(resource)
  #  if current_user.admin?
  #    admin_root_path
  #  else
  #    edit_vendor_registration_path
  #  end
    case resource
    when Vendor
      edit_vendor_registration_path
    when User
      root_url
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit({ roles: [] }, :first_name, :last_name, :email, :password, 
      :password_confirmation, :role, :company_name, :website, :verification_file, :ein, :ssn) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit({ roles: [] }, :first_name, :last_name, :email, :password, 
      :password_confirmation, :timezone, :current_password, :company_name, :ein, :ssn, :dob_month, :dob_day, :dob_year, 
      :routing_number, :account_number, :website, :verification_file) }
  end

  private

  def set_timezone
    tz = current_user ? current_user.timezone : nil
    Time.zone = tz || ActiveSupport::TimeZone["London"]
  end
end
