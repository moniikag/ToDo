require "spec_helper"

describe "Signing up: " do
	it "allows a user to sign up for the site and creates the object in the same database" do

		visit "/"
		click_link "sign-up-link"
		expect(page).to have_content("Register")

		fill_in "user_email", with: "example@example.tom"
		fill_in "user_password", with: "12345abcd"
		fill_in "user_password_confirmation", with: "12345abcd"
		click_button "Sign Up"

		expect(current_path).to eq(new_user_sessions_path)
		expect(page).to have_content("User was successfully created. Please confirm your email.")
	end

	context "confirming email: " do
		let!(:user) { FactoryGirl.create(:user) }
		let(:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }

		it "allows user to confirm email for the first time" do
			visit confirm_email_users_url(email: unconfirmed_user.email, activation_token: unconfirmed_user.activation_token)
			expect(current_path).to eq(root_path)
			expect(page).to have_content("Your email was successfully confirmed")
		end

		it "doesn't allow user to confirm email many times" do
      token = unconfirmed_user.activation_token
      unconfirmed_user.update_attribute('activation_token', nil)
			visit confirm_email_users_url(email: unconfirmed_user.email, activation_token: token)
			expect(current_path).to eq(new_user_sessions_path)
			expect(page).to have_content("The activation link has already been used or is invalid")
		end

		it "doesn't allow logged in user to confirm email - Pundit error" do
			log_in
      expect {
        visit confirm_email_users_url(email: user.email, activation_token: user.activation_token)
      }. to raise_error(Pundit::NotAuthorizedError)
		end
	end

end
