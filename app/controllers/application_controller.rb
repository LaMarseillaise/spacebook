class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :save_return_address

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation,
                :birthday, :gender)
    end
  end

  def save_return_address
    session[:return_to] ||= request.referer
  end
end
