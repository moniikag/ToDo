class InvitationsController < ApplicationController
 before_action :skip_authorization

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = User.find_by_email(params[:user_email])
    unless @invitation.user.nil? 
      if @invitation.save
        UserMailer.invitation(@invitation).deliver
        flash[:success] = "Invitation was successfully sent. User has now acces to your todo list"
        redirect_to root_path
      else
        flash[:error] = "There was a problem with sending your invitation."
      end
    else
      flash[:error] = "."
    end
    redirect_to root_path
  end

  def destroy
  end

  private

  def invitation_params
    params.require(:invitation).permit(:user_id, :todo_list_id)
  end

end
