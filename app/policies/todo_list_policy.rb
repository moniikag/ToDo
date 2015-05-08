class TodoListPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.where(user_id: @user.id)
    end
  end

  def index?
    !!@user
  end

  def new?
    !!@user
  end

  def create?
    new?
  end

  def show?
    edit?
  end

  def send_reminder?
    index?
  end

  def edit?
    @user && @record.user_id == @user.id
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

end