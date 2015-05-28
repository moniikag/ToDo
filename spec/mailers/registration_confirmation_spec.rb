require 'spec_helper'

RSpec.describe "Registration confirmation" do
  let!(:user) { FactoryGirl.create(:user) }
  let(:mail) { UserMailer.registration_confirmation(user) }

  it 'renders the subject' do
    expect(mail.subject).to eql('Registration Confirmation')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eql([user.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eql(['app34940850@heroku.com'])
  end

  it 'assigns user name' do
    user.update_attribute('first_name', "john")
    expect(mail.body.encoded).to match("#{user.first_name}")
  end

  it 'assigns confirmation_url' do
    link = confirm_email_users_url(email: user.email, token: user.activation_token)
    expect(mail.body).to have_content(link)
  end
end
