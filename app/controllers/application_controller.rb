class ApplicationController < ActionController::Base
  class AccessDenied < StandardError; end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  rescue_from AccessDenied, with: :record_not_found


  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def record_not_found
    render file: 'public/404.html', status: 404, layout: false
  end
end
