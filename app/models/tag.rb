class Tag < ActiveRecord::Base
  has_and_belongs_to_many :todo_items

  validates :name, uniqueness: true 
end
