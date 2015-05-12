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

		it "allows user to confirm email for the first time" do
			user.update_attribute('email_confirmed', false)
			visit "/users/#{user.id}/confirm_email"
			expect(current_path).to eq(new_user_sessions_path)
			expect(page).to have_content("Your email was successfully confirmed")
		end

		it "doesn't allow user to confirm email many times" do
			visit "/users/#{user.id}/confirm_email"
			expect(current_path).to eq(new_user_sessions_path)
			expect(page).to have_content("Your email has already been confirmed")
		end
	end

end