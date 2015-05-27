class SendReminder

  def self.call(current_user:, todo_lists:)
    urgent_items = todo_lists.flat_map(&:todo_items).select(&:urgent?)
    UserMailer.reminder(urgent_items, current_user).deliver
  end

end
