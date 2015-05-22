class TodoItem < ActiveRecord::Base

  belongs_to :todo_list
  has_and_belongs_to_many :tags

  validates :content, presence: true,
    length: { minimum: 2 }
  validates :deadline, presence: true

  scope :complete, -> { where("completed_at is not null") }
  scope :incomplete, -> { where(completed_at: nil) }

  def completed?
    completed_at.present?
  end

  def urgent?
    self.deadline < 25.hours.from_now
  end

  def tag_list
    TagService.new(todo_item: self).tag_list
  end

  def tag_list=(tags_given)
    TagService.new(todo_item: self, tags: tags_given).set_tag_list
  end

end
