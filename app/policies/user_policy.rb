class UserPolicy < ApplicationPolicy

  def permitted_attributes
    [:first_name, :last_name, :email, :password, :password_confirmation]
  end

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