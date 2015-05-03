require 'spec_helper'

describe 'Todo Items: ' do

  let!(:user) { User.create!(first_name: "example", last_name: "example", email: "example@example.com", password: "password", password_confirmation: "password") }
  let!(:todo_list) { user.todo_lists.create!(title: "Groceries", description: "Grocery list") }
  let!(:todo_item) { todo_list.todo_items.create!(content: "Item", deadline: Time.now) }

  def log_in
    visit "/user_sessions/new"
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
    expect(page).to have_content("Thanks for logging in!")
  end

  context "Creating new item" do
    before(:each) { log_in }

    it "is successful with valid content" do
      visit "/todo_lists/#{todo_list.id}/todo_items"
      click_link "New Todo Item"
      fill_in "Content", with: "Item 2"
      click_button "Save"
      expect(page).to have_content("Added todo list item.")
      expect(page).to have_content("Item 2")
    end

    it "displays an error with no content" do
      visit "/todo_lists/#{todo_list.id}/todo_items"
      click_link "New Todo Item"
      fill_in "Content", with: ""
      click_button "Save"
      expect(page).to have_content("There was a problem adding that todo list item.")
      expect(page).to have_content("Content can't be blank") 
    end

    it "displays an error with content less than 2 characters long" do
      visit "/todo_lists/#{todo_list.id}/todo_items"
      click_link "New Todo Item"
      fill_in "Content", with: "X"
      click_button "Save"
      expect(page).to have_content("There was a problem adding that todo list item.")
      expect(page).to have_content("Content is too short") 
    end
  end

end


