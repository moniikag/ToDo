class UserMailer < ApplicationMailer
  def reminder(urgent_items)
  	@urgent_items = urgent_items
  	mail(to: 'monikaglier@gmail.com', subject: 'Reminder from Todo List')
  end
end

