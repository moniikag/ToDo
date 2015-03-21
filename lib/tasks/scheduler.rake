desc "This task is called by the Heroku scheduler add-on"

task :remind => :environment do
  mail = Mail.new do
	  to 'monikaglier@gmail.com'
	  from 'sender@example.comt'
	  subject 'testing sending e-mail'
	  body 'Sending email with Ruby through SendGrid!'
  end
  mail.delivery_method :sendmail
  mail.deliver
end