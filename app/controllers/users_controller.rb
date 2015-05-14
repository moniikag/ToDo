class UsersController < ApplicationController
  before_action :get_resources, except: [:confirm_email]
  skip_before_action :authenticate_user, only: [:new, :create, :confirm_email]

  def new
    authorize User, :new?
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    authorize User, :create?
    @user = User.new(permitted_attributes(User.new))
    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      redirect_to new_user_sessions_path, notice: 'User was successfully created. Please confirm your email.'
    else
      render action: 'new'
    end
  end

  def confirm_email
    @user = User.find_by_email_and_activation_token(params[:email], params[:activation_token])
    authorize @user || User
    @user.activate!
    flash[:success] = 'Your email was successfully confirmed. You can now log in.'
  rescue Pundit::NotAuthorizedError
    flash[:error] = 'The activation link has already been used or is invalid. Please try to log in.'
  ensure
    redirect_to new_user_sessions_path
  end

  def update
    if @user.update_attributes(permitted_attributes(@user))
      redirect_to root_path, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private
  def get_resources
    @user = User.find(params[:id]) if params[:id]
    authorize @user if @user
  end

end
