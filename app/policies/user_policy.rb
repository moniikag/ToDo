class UserPolicy < ApplicationPolicy

  def new?
    !@user
  end

  def create?
    !@user
  end

  def show?
    edit?
  end

  def edit?
    @user && @record.id == @user.id
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

end