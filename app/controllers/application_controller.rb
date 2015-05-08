class ApplicationController < ActionController::Base

  include Pundit
  after_action :verify_authorized
  # , :except => :index

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user

  def current_user
  	@current_user ||= User.find_by_id(session[:user_id] || cookies[:user_id])
  end

  helper_method(:current_user)

  def authenticate_user
  	redirect_to new_user_sessions_path unless current_user
  end

end
