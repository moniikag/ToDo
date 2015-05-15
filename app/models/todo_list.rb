class TodoList < ActiveRecord::Base

  has_many :todo_items
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 5 }

  def has_completed_items?
    todo_items.complete.count > 0
  end

  def has_incomplete_items?
    todo_items.incomplete.count > 0
  end
end
