class InvitationPolicy < ApplicationPolicy

  def permitted_attributes
    [:invited_user_email]
  end

  def new?
    !!@user
  end

  def create?
    new?
  end

  def confirm?
    @record.try(:invitation_token)
  end

  def destroy?
  end

end
