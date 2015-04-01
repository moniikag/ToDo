class UserMailer < ApplicationMailer
  def reminder(urgent_items)
  	@urgent_items = urgent_items
  	mail(to: 'monikaglier@gmail.com', subject: 'checkout email from ActionMailer')
  end
end





#def reminder(urgent_items)
#  	@urgent_items = urgent_items
#  	mail(to: 'monikaglier@gmail.com', subject: 'checkout email from ActionMailer')
#end