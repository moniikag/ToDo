require "spec_helper" 

describe "Signing up: " do
	it "allows a user to sign up for the site and creates the object in the same database" do
		
		visit "/" 
		click_link "sign-up-link"
		expect(page).to have_content("Register")

		fill_in "user_first_name", with: "Name"
		fill_in "user_last_name", with: "Surname"
		fill_in "user_email", with: "example@example.tom"
		fill_in "user_password", with: "12345abcd"
		fill_in "user_password_confirmation", with: "12345abcd"
		click_button "sign-up"

		expect(current_path).to eq(new_user_sessions_path)
		expect(page).to have_content("User was successfully created. Please confirm your email.")
	end

	context "confirming email: " do
		let!(:user) { FactoryGirl.create(:user) }
		let!(:link) { confirm_email_user_url(user, token: user.activation_token) }

		it "allows user to confirm email for the first time" do
			visit link
			expect(current_path).to eq(new_user_sessions_path)
			expect(page).to have_content("Your email was successfully confirmed")
		end

		it "doesn't allow user to confirm email many times" do
			user.update_attribute('activation_token', nil)
			visit link
			expect(current_path).to eq(new_user_sessions_path)
			expect(page).to have_content("The activation link has already been used or is invalid")
		end

		it "doesn't allow logged in user to confirm email again - before filter user logged in" do
			user.update_attribute('activation_token', nil)
			log_in
			visit link
			expect(current_path).to eq(root_path)
			expect(page).to have_content("You're already logged in")
		end
	end

end