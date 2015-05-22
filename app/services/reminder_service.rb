class ReminderService

  def initialize(todo_lists:)
    @todo_lists = todo_lists
  end

  def return_urgent_items
    urgent_items = []
    @todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        urgent_items << todo_item if todo_item.urgent?
      end
    end
    urgent_items
  end

end
