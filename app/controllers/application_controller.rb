class ApplicationController < ActionController::Base

  before_action :authenticate_user

  include Pundit
  after_action :verify_authorized
  protect_from_forgery with: :exception

  def current_user
  	@current_user ||= User.find_by_id(session[:user_id] || cookies[:user_id])
  end

  helper_method(:current_user)

  def authenticate_user
  	redirect_to new_user_sessions_path unless current_user
  end

 def user_not_authorized(exception) #pundit rescue
   policy_name = exception.policy.class.to_s.underscore
   flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
   redirect_to(request.referrer || root_path)
 end

end
