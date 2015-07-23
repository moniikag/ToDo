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
    expect(mail.from).to eql(['app34940850@heroku.com'])
  end

  it 'assigns invited user email' do
    expect(mail.body.encoded).to match("#{invitation.user.email}")
  end

  it 'assings inviting_user email' do
    expect(mail.body.encoded).to match(inviting_user.email)
  end

  it 'assings new_user_url if invitation sent to nonexistent user' do
    invitation.update_attribute('invited_user_email', 'no@user.email')
    expect(mail.body).to have_content(new_user_url)
  end

  it "it doesn't assing new_user_url if invitation sent to existing user" do
    expect(mail.body).to_not have_content(new_user_url)
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
