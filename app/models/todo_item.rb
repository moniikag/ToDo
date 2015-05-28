class TodoItem < ActiveRecord::Base

  belongs_to :todo_list

  validates :content, presence: true, length: { minimum: 2 }

  scope :complete, -> { where("completed_at is not null") }
  scope :incomplete, -> { where(completed_at: nil) }

  acts_as_taggable

  def urgent?
    self.deadline < 25.hours.from_now if self.deadline.present?
  end

end
