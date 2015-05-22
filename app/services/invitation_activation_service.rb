class InvitationActivationService

  def initialize(invitation:)
    @invitation = invitation
  end

  def activate!
    @invitation.update_attribute('invitation_token', nil)
    @invitation.update_attribute('user_id', User.find_by_email(@invitation.invited_user_email).id) if @invitation.user_id.nil?
  end

end
