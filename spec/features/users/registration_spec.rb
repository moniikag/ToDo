require "spec_helper"

describe "Signing up" do
	it "allows a user to sign up for the site and creates the object in the same database" do
		
		expect(User.count).to eq(0)

		visit "/" 
		click_link "Sign Up"
		expect(page).to have_content("Register")

		fill_in "First Name", with: "Name"
		fill_in "Last Name", with: "Surname"
		fill_in "Email", with: "example@example.tom"
		fill_in "Password", with: "12345abcd"
		fill_in "Password (again)", with: "12345abcd"
		click_button "Sign Up"

		expect(User.count).to eq(1)
	end

end