class ReminderService

  def self.call(todo_lists:)
    urgent_items = []
    todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        urgent_items << todo_item if todo_item.urgent?
      end
    end
    urgent_items
  end

end
