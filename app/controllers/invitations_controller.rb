class InvitationsController < ApplicationController
 before_action :skip_authorization
 before_action :get_resources

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = User.find_by_email(params[:user_email])
    @invitation.generate_invitation_token
    unless @invitation.user.nil?
      if @invitation.save
        UserMailer.invitation(@invitation).deliver
        flash[:success] = "Invitation was successfully sent. User now needs to confirm acces to your todo list"
        redirect_to root_path
      else
        flash[:error] = "There was a problem with sending your invitation."
      end
    else
      flash[:error] = "There is no user like this."
    end
    redirect_to todo_list_todo_items_path(@todo_list)
  end

  def destroy
  end

  private

  def get_resources
    @todo_list = policy_scope(TodoList).find(params[:todo_list_id])
  end

  def invitation_params
    params.require(:invitation).permit(:todo_list_id)
  end

end
