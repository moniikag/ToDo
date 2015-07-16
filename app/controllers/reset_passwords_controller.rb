class ResetPasswordsController < ApplicationController
  skip_before_action :authenticate_user
  before_action :ensure_no_user
  before_action :pundit_authorize_user

  def new
  end

  def create
    if @user = User.find_by_email(params[:email])
      PasswordResetter.new(user: @user).generate_token
      UserMailer.password_reset(@user).deliver
      flash[:success] = "We've sent further information to your email address."
      redirect_to root_path
    else
      flash[:error] = "There is no user like that!"
      render :new
    end
  end

  def edit
    @user = User.where(password_token: params[:token]).first
  end

  def update
    @user = User.where(password_token: params[:token]).first
    if @user && @user.email == params[:email] && @user.update_attributes(user_params)
      @user.update_attributes(password_token: nil, password_token_generated: nil)
      redirect_to root_path, notice: 'Your password was successfully updated. You can now log in.'
    else
      flash[:error] = "Plesae try again."
      render :edit
    end
  end

  private
  def user_params
    params.permit(:password, :password_confirmation)
  end

  def pundit_authorize_user
    authorize :reset_password
  end
end
