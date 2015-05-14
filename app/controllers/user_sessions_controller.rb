class UserSessionsController < ApplicationController

	skip_before_action :authenticate_user, only: [:new, :create]
  skip_after_action :verify_authorized, only: [:destroy]

  def new
    authorize User, :new?
  end

  def create
    authorize User, :new?
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.activation_token == nil
        cookies.permanent[:user_id] = user.id
        flash[:success] = "Thanks for logging in!"
        redirect_to todo_lists_path
      else
        flash[:error] = "You need to confirm your email first."
        render action: 'new'
      end
    else
      flash[:error] = "There was a problem loggin in. Please check your email and password."
      render action: 'new'
    end
  end

  def destroy
    cookies[:user_id] = nil
    flash[:success] = "You have successfully logged out."
    redirect_to root_path
  end

end
