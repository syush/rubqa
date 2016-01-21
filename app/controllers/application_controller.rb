class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_user_in_cookie

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: { message: exception.message }, status: :forbidden }
      format.js do |exception|
        @message = exception.message
        render 'common/not_authorized'
      end
    end
  end

  check_authorization unless :devise_controller?

  protected

  def set_user_in_cookie
    cookies[:user_id] = user_signed_in? ? current_user.id : 'guest'
  end



end
