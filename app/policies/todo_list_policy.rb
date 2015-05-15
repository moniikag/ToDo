class TodoListPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      # owned_todo_lists = scope.where(user_id: @user.id)
      invited_todo_lists = scope.includes(:invited_users).where('todo_lists.user_id = ? OR (invitations.user_id = ? AND invitations.invitation_token IS NULL)', @user.id, @user.id) ### activation irrelevant
      # scope = owned_todo_lists + invited_todo_lists
    end
  end

  def permitted_attributes
    [:title, :description]
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
