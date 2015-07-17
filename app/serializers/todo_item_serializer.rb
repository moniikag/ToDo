class TodoItemSerializer < ActiveModel::Serializer
  attributes :id, :content, :deadline, :deadline_formatted, :tag_list

  def deadline_formatted
    object.deadline.try(:strftime, '%d/%m/%Y %H:%M')
  end

  def tag_list
    object.tag_list
  end
end
