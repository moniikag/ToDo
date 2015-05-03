require 'spec_helper'

describe TodoItemsController do

  let!(:user) { User.create!(first_name: "example", last_name: "example", email: "example@example.com", password: "password", password_confirmation: "password") }
	let!(:other_user) { User.create!(first_name: "test", last_name: "test", email: "test@example.com", password: "password", password_confirmation: "password") }

	let!(:todo_list) { user.todo_lists.create!(title: "Groceries", description: "Grocery list") }
	let!(:todo_item) { todo_list.todo_items.create!(content: "Item 1", deadline: Time.now) }

	let!(:other_todo_list) { other_user.todo_lists.create!(title: "Fruits", description: "Fruits list") }
	let!(:other_todo_item) { other_todo_list.todo_items.create!(content: "Apple", deadline: Time.now) }


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

    it "redirects to login page on todo items list" do
      visit "/todo_lists/#{todo_list.id}/todo_items"
    end

    it "redirects to login page on todo item edit" do
      visit "/todo_lists/#{todo_list.id}/todo_items/#{todo_item.id}/edit"
    end
  end

  context "user is logged in" do
    before(:each) { log_in }

  	it 'displays todo item for current_user' do
      log_in
  		visit "/todo_lists/#{todo_list.id}/todo_items"
      expect(response.status).to eq(200)
  		expect(page).to have_content("Item 1")
  	end

  	it "does not display todo_item that doesn't belong to current_user" do
      log_in
  		expect { visit "/todo_lists/#{other_todo_list.id}/todo_items" }.to raise_error(ActiveRecord::RecordNotFound)
  	end
    
  end

end


