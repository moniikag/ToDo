class TodoListPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve # owned todo_lists + invited todo_lists
      scope.includes(:invited_users).where('todo_lists.user_id = ?
        OR (invitations.user_id = ? AND invitations.invitation_token IS NULL)', @user.id, @user.id).references(:invitations)
    end
  end

  def permitted_attributes
    [:title, :description]
  end

  def index?
    !!@user
  end

  def search?
    index?
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
    @user && ((@record.user_id == @user.id) || @record.invited_user_ids.include?(@user.id))
  end

  def update?
    edit?
  end

  def done?
    edit?
  end

  def destroy?
    edit?
  end

end
