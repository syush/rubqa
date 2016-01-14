class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_user_in_cookie

  protected

  def set_user_in_cookie
    cookies[:user_id] = user_signed_in? ? current_user.id : 'guest'
  end
end
