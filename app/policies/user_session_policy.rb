class UserSessionPolicy < ApplicationPolicy

  def new?
    !@user
  end

  def create?
    !@user
  end

  def destroy?
    !!@user
  end

end