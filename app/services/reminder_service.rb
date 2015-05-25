class ReminderService

  def initialize(current_user:, todo_lists:)
    @current_user = current_user
    @todo_lists = todo_lists
  end

  def send_message
    urgent_items = []
    @todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        urgent_items << todo_item if todo_item.urgent?
      end
    end
    UserMailer.reminder(urgent_items, @current_user).deliver
  end

end
