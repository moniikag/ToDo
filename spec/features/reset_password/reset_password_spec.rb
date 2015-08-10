require 'spec_helper'

describe "Resetting password" do
  let(:user) { FactoryGirl.create(:user) }

  context "sending reset-password-link" do
    it "doesn't allow logged in user to send reset-password-link" do
      visit "/"
      expect(page).to have_content("Log In")
      fill_in "email", with: user.email
      fill_in "password", with: user.password
      click_button "Log In"
      expect(page).to have_content("Thanks for logging in!")
      visit "/reset_passwords/new"
      expect(page).to_not have_button("Reset password")
    end

    it "allows not logged in user to send reset-password-link" do
      visit "/"
      expect(page).to have_content("Log In")
      click_link "Forgot password?"
      expect(page).to have_button("Reset password")
      fill_in "email", with: user.email
      click_button "Reset password"
      expect(page).to have_content("We've sent further information")
    end
  end

  context "following reset-password-link" do
    it "brings user to reset-password-page and allows to reset password" do
      PasswordResetter.new(user: user).generate_token
      visit new_password_reset_passwords_url(token: user.password_token)
      expect(page).to have_content("Password (again)")
      fill_in "password", with: 'password'
      fill_in "password_confirmation", with: 'password'
      click_button "Reset password"
      expect(page).to have_content("Your password was successfully updated")
    end
  end
end
