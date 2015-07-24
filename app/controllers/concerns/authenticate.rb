module Authenticate

  def self.included(location)
    location.helper_method :current_user
  end

  def sign_in(user)
    cookies.permanent[:user_id] = user.id
  end

  def sign_out
    cookies[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id] || cookies[:user_id])
  end

  def authenticate_user
    redirect_to new_user_sessions_path unless current_user
  end

  def ensure_no_user
    if current_user
      flash[:info] = "This action is only allowed for users that are not logged in."
      redirect_to todo_lists_path
    end
  end

end
