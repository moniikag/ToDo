require 'spec_helper'

describe 'Displaying todo_list' do

  let!(:user) { User.create!(first_name: "example", last_name: "example", email: "example@example.com", password: "password", password_confirmation: "password") }
	let!(:other_user) { User.create!(first_name: "test", last_name: "test", email: "test@example.com", password: "password", password_confirmation: "password") }

	let!(:todo_list) { user.todo_lists.create!(title: "Groceries", description: "Grocery list") }
	let!(:other_todo_list) { other_user.todo_lists.create!(title: "Fruits", description: "Fruit list") }

	def log_in
    visit "/user_sessions/new"
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
    expect(response.status).to eq(200)
    expect(page).to have_content("Thanks for logging in!")
  end

  context "user is not logged in" do

    after(:each) do
      expect(response.status).to eq(200)
      expect(page.current_path).to eql('/user_sessions/new')
    end

    it "redirects to login page on todo list show" do
      visit "/todo_lists/#{todo_list.id}"
    end

    it "redirects to login page on todo list edit" do
      visit "/todo_lists/#{todo_list.id}/edit"
    end

  end

  context "user is logged in" do
  	before(:each) {log_in}

		it 'displays todo list for current_user' do
			visit "/todo_lists"
			expect(page).to have_content("Groceries")
			expect(response.status).to eq(200)
		end

		it "does not display todo lists that doesn't belong to current_user" do
			visit "/todo_lists"
			expect(page).to_not have_content("Fruits")
		end

		it "does not allow user enter todo list that doesn't belog to him" do
			expect { visit "/todo_lists/#{other_todo_list.id}" }.to raise_error(ActiveRecord::RecordNotFound)
		end

	end

end











