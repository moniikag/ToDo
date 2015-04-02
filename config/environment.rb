# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Odot::Application.initialize!

#require 'mail'

#Mail.defaults do
#  delivery_method :smtp, {
#    :address => 'smtp.sendgrid.net',
#    :port => '587',
#    :domain => 'heroku.com',
#    :user_name => ENV['SENDGRID_USERNAME'],
#    :password => ENV['SENDGRID_PASSWORD'],
#   :authentication => :plain,
#    :enable_starttls_auto => true
#  }
#end

  #config.action_mailer.default_url_options = { :host => 'localhost:3000'}
  #config.action_mailer.default_url_options = { :host => 'smtp.sendgrid.net'}
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.perform_deliveries = true 
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
  #:address        => 'smtp.gmail.com',
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  #:user_name      => "tested for gmail username", - worked
  #:password       => "tested for gmail password",
  :user_name      => "app34940850@heroku.com",
  :password       => "gldlcuwr",
  #:user_name      => ENV['SENDGRID_USERNAME'],
  #:password       => ENV['SENDGRID_PASSWORD'],
  #:domain         => 'gmail.com',
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}