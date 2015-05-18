require 'spec_helper'

RSpec.describe "Invitation" do
  let(:inviting_user) { FactoryGirl.create(:user) }
  let(:invited_user) { FactoryGirl.create(:user) }
  let(:invitation) { FactoryGirl.create(:invitation, invited_user_email: invited_user.email) }
  let(:mail) { UserMailer.invitation(invitation, inviting_user) }

  it 'renders the subject' do
    expect(mail.subject).to eql('Invitation to TodoList')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eql([invitation.invited_user_email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eql(['testingemail486@gmail.com'])
  end

  it 'assigns invited user name' do
    invited_user.update_attribute('first_name', "john")
    expect(mail.body.encoded).to match("#{invitation.user.first_name}")
  end

  it 'assings inviting_user email' do
    expect(mail.body.encoded).to match(inviting_user.email)
  end

  it 'assigns invitation_url' do
    link = confirm_todo_list_invitations_url(invitation.todo_list, token: invitation.invitation_token, email: invitation.invited_user_email)
    expect(mail.body).to have_content(link)
  end

  it 'assigns todo_list_url' do
    link = todo_list_todo_items_url(todo_list_id: invitation.todo_list_id)
    expect(mail.body).to have_content(link)
  end
end