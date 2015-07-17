class TodoList < ActiveRecord::Base

  has_many :todo_items
  belongs_to :user

  has_many :invitations
  has_many :invited_users, class_name: "User", through: :invitations, source: :user

  validates :title, presence: true

  def has_completed_items?
    todo_items.complete.count > 0
  end

  def has_incomplete_items?
    todo_items.incomplete.count > 0
  end
end
