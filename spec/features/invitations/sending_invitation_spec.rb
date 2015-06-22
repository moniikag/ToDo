require 'spec_helper'

describe 'Sending invitation' do
  let!(:user) { FactoryGirl.create(:user) }
  let(:todo_list) { FactoryGirl.create(:todo_list, user: user) }

  let(:user_to_invite) { FactoryGirl.create(:user) }
  let(:previous_invitation) { FactoryGirl.create(:invitation, todo_list: todo_list, invited_user_email: user_to_invite.email) }

  it "allows to send an invitation for the first time" do
    log_in
    visit "/todo_lists/#{todo_list.id}"
    find('.share').click
    fill_in "invitation_invited_user_email", with: user_to_invite.email
    click_button "Done"
    expect(page).to have_content('Invitation was successfully sent')
    expect(current_path).to eq(todo_list_path(id: todo_list.id))
  end

  it "doesn't allow te send another invitation to the same user & same todo list" do
    previous_invitation
    log_in
    visit "/todo_lists/#{todo_list.id}"
    find('.share').click
    fill_in "invitation_invited_user_email", with: user_to_invite.email
    click_button "Done"
    expect(page).to have_content('There was a problem sending your invitation.')
    expect(current_path).to eq(todo_list_path(id: todo_list.id))
  end

  it "doesn't allow te send invitation with invalid email" do
    log_in
    visit "/todo_lists/#{todo_list.id}"
    find('.share').click
    fill_in "invitation_invited_user_email", with: "email"
    click_button "Done"
    expect(page).to have_content('There was a problem sending your invitation.')
    expect(current_path).to eq(todo_list_path(id: todo_list.id))
  end

  it "doesn't allow te send invitation to user himself" do
    log_in
    visit "/todo_lists/#{todo_list.id}"
    find('.share').click
    fill_in "invitation_invited_user_email", with: user.email
    click_button "Done"
    expect(page).to have_content("There was a problem sending your invitation.")
    expect(current_path).to eq(todo_list_path(id: todo_list.id))
  end
end
