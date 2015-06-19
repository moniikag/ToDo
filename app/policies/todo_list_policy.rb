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

  def create?
    !!@user
  end

  def show?
    update?
  end

  def update?
    @user && ((@record.user_id == @user.id) || @record.invited_user_ids.include?(@user.id))
  end

  def prioritize?
    update?
  end

  def done?
    update?
  end

  def destroy?
    update?
  end

end
