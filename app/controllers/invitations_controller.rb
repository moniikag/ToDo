class InvitationsController < ApplicationController
  before_action :get_resources

  def new
    authorize Invitation
    @invitation = @todo_list.invitations.new
  end

  def create
    authorize Invitation
    @invitation = @todo_list.invitations.new(permitted_attributes(Invitation.new))
    if @invitation.save
      UserMailer.invitation(@invitation, current_user).deliver
      flash[:success] = "Invitation was successfully sent. User now needs to confirm access to your TodoList"
      redirect_to todo_list_todo_items_path(@todo_list)
    else
      flash[:error] = "There was a problem with sending your invitation."
      render action: :new
    end
  end

  def confirm #invited user accepts invitation to todo list
    @invitation = Invitation.find_by_invited_user_email_and_invitation_token(params[:email], params[:token])
    authorize @invitation || Invitation
    @todo_list = @invitation.todo_list
    @invitation.activate!
    flash[:success] = "Access to TodoList was successfully activated."
    redirect_to root_path
  rescue Pundit::NotAuthorizedError
    flash[:error] = "You have already activated access to the todo list or the link is invalid"
    redirect_to root_path
  end

  def destroy
  end

  private

  def get_resources
    @todo_list = TodoList.find(params[:todo_list_id])
  end

end
