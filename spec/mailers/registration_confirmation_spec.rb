require 'spec_helper'
 
RSpec.describe "Registration confirmation" do
  let!(:user) { FactoryGirl.create(:user) }
  let(:mail) { UserMailer.registration_confirmation(user) }

  it 'renders the subject' do
    expect(mail.subject).to eql('Registration Confirmation')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eql(['monikaglier@gmail.com'])
  end

  it 'renders the sender email' do
    expect(mail.from).to eql(['testingemail486@gmail.com'])
  end

  it 'assigns user name' do
    expect(mail.body.encoded).to match(user.first_name)
  end

  it 'assigns confirmation_url' do
    link = confirm_email_user_url(user, token: user.activation_token)
    expect(mail.body).to have_content(link)
  end
end

