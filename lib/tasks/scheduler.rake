desc "This task is called by the Heroku scheduler add-on"

task :remind => :environment do
  Mail.deliver do
	  to 'monikaglier@gmail.com'
	  from 'myaplication@heroku.com'
	  subject 'testing send mail'
	  body 'Sending email with Ruby through SendGrid!'
  end
end