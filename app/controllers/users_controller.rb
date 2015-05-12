class UsersController < ApplicationController
  before_action :get_resources
  before_action :ensure_user_not_logged_in, only: [:new, :create, :confirm_email]
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
      redirect_to root_path, notice: 'User was successfully created. Please confirm your email.' 
    else
      render action: 'new' 
    end
  end

  def confirm_email
    @user.update_attribute('email_confirmed', true)
    flash[:success] = 'Your email was successfully confirmed. You can now log in.'
    redirect_to new_user_sessions_path
  end

  def update
    respond_to do |format|
      if @user.update_attributes(permitted_attributes(@user))
        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @user == current_user
      @user.destroy
      respond_to do |format|
        format.html { redirect_to root_url }
        format.json { head :no_content }
      end
    else
      redirect_to root_path
    end
  end

  private
  def get_resources
    @user = User.find(params[:id]) if params[:id]
    authorize @user if @user
  end

  def ensure_user_not_logged_in
    redirect_to root_path if current_user
  end

end
