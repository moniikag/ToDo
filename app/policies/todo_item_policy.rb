class TodoItemPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.where(todo_list_id: @user.todo_list_ids)
    end
  end

  def permitted_attributes
    [:content, :deadline]
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

  def edit?
    @user && @record.todo_list.user_id == @user.id
  end

  def update?
    edit?
  end

  def complete?
    edit?
  end

  def destroy?
    edit?
  end

end
