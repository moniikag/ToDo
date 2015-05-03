require "spec_helper"

describe "Logging In" do

	let!(:user) { User.create!(first_name: "example", last_name: "example", email: "example@example.com", password: "password", password_confirmation: "password") }

	it "logs the user in and goes to the todo lists" do
		visit "/user_sessions/new"
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
		expect(page).to have_content("Todo Lists")
		expect(page).to have_content("Thanks for logging in!")
	end

	it "displays the email address in the event of a failed login" do 
		visit "/user_sessions/new"
    fill_in "email", with: user.email
    fill_in "password", with: "something"
    click_button "Log In"
		expect(page).to have_content("Please check your email and password")
		expect(page).to have_field("Email", with: "example@example.com")
	end
end