class UserPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.where(activation_token: nil)
    end
  end

  def permitted_attributes
    [:email, :password, :password_confirmation]
  end

  def new?
    !@user
  end

  def create?
    !@user
  end

  def confirm_email?
    !@user && @record.try(:activation_token)
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
