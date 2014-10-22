class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_sign_in

  private

  def sign_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def sign_out
    @current_user = nil
    session.delete(:user_id)
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def signed_in?
    !!current_user
  end
  helper_method :signed_in?

  def require_current_user
    unless current_user && params[:id] == current_user.id.to_s
      flash[:error] = "Inadequate authorization"
      redirect_to root_path
    end
  end

  def require_sign_in
    unless signed_in?
      flash[:error] = "Please sign in before viewing content."
      redirect_to root_path
    end
  end
end