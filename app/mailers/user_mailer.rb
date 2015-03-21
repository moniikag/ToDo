class UserMailer < ApplicationMailer
 
  def reminder
  	mail(to: 'monikaglier@gmail.com', subject: 'checkout email from ActionMailer')
  end
end
