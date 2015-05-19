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

  def tag_list
    self.tags.map { |t| t.name }.join(", ")
  end

  def tag_list=(tags_given)
    if tags_given
      tag_names = tags_given.split(/\s*,\s*/)
      self.tags = tag_names.map { |name| Tag.where('name = ?', name).first or Tag.create(:name => name)}
    end
  end

  def urgent?
    self.deadline < 25.hours.from_now
  end

end
