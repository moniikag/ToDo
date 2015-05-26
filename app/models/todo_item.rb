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

  def tag_list
    self.tags.map { |t| t.name }.join(", ")
  end

  def tag_list=(tags_given)
    if tags_given
      tag_names = tags_given.split(/,+/)
      tag_names.map! {|tag| tag.strip }
      self.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
    end
  end

end
