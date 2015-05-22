class TodoItem < ActiveRecord::Base

  belongs_to :todo_list
  has_and_belongs_to_many :tags

  validates :content, presence: true, length: { minimum: 2 }
  validates :deadline, presence: true

  scope :complete, -> { where("completed_at is not null") }
  scope :incomplete, -> { where(completed_at: nil) }

  def urgent?
    self.deadline < 25.hours.from_now
  end

end
