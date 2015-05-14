require 'spec_helper'

describe "Logging in" do
  let!(:user) { FactoryGirl.create(:user) }
  let(:activation_token) { SecureRandom.hex(8) }

  it "doesn't allow user to log in when email not confirmed" do
    user.update_attribute('activation_token', activation_token)
    visit "/"
    expect(page).to have_content("Log In")
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
    expect(page).to have_content("You need to confirm your email first")
  end

  it "allows user to log in when email confirmed" do
    visit "/"
    expect(page).to have_content("Log In")
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
    expect(page).to have_content("Thanks for logging in!")
  end

end
