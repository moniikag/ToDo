require 'spec_helper'

describe "Logging in" do
  let!(:user) { FactoryGirl.create(:user) }
  
  it "allows the user to log in" do
    visit "/"
    expect(page).to have_content("Log In")
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
    expect(page).to have_content("Thanks for logging in!")
  end

end