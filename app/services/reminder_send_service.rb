class ReminderSendService

  def self.call(current_user:, todo_lists:)
    urgent_items = []
    todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        urgent_items << todo_item if todo_item.urgent?
      end
    end
    UserMailer.reminder(urgent_items, current_user).deliver
  end

end
