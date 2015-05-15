class InvitationsController < ApplicationController
  before_action :skip_authorization
  before_action :get_resources

  def new
    @invitation = @todo_list.invitations.new
  end

  def create
    @invitation = @todo_list.invitations.new(invitation_params)
    if @invitation.save
      UserMailer.invitation(@invitation, current_user).deliver
      flash[:success] = "Invitation was successfully sent. User now needs to confirm access to your TodoList"
      redirect_to todo_list_todo_items_path(@todo_list)
    else
      flash[:error] = "There was a problem with sending your invitation."
      render action: :new
    end
  end

  def confirm #invited user confirms acceptance of invitation to todo list
    @invitation = Invitation.find_by_invited_user_email_and_invitation_token(params[:email], params[:token])
    @todo_list = @invitation.todo_list
    # authorize @invitation || Invitation
    @invitation.activate!
    flash[:success] = "Access to TodoList was successfully activated."
    redirect_to todo_list_todo_items_path(@todo_list)
  rescue Pundit::NotAuthorizedError
    flash[:error] = "You have already activated access to the todo list or the link is invalid"
    redirect_to root_path
  end

  def destroy
  end

  private

  def get_resources
    @todo_list = policy_scope(TodoList).find(params[:todo_list_id])
  end

  def invitation_params
    params.require(:invitation).permit(:invited_user_email)
  end

end
