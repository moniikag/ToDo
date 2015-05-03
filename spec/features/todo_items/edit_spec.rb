require 'spec_helper'

describe 'Todo items: ' do

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

  context "Editing an item" do

    before(:each) { 
      log_in
      visit "/todo_lists/#{todo_list.id}/todo_items" 
      within("#todo_item_#{todo_item.id}") do
        click_link "Edit"
      end
    }

      it "is successful with valid content" do
        fill_in "Content", with: "One item"
        click_button "Save"
        expect(page).to have_content("Saved todo list item.")
        todo_item.reload
        expect(todo_item.content).to eq("One item")
      end

      it "is unsuccessful with no content" do
        fill_in "Content", with: ""
        click_button "Save"
        expect(page).to_not have_content("Saved todo list item.")
        expect(page).to have_content("Content can't be blank")
        todo_item.reload
        expect(todo_item.content).to eq("Item")
      end

      it "is unsuccessful with not enough content" do
        fill_in "Content", with: "1"
        click_button "Save"
        expect(page).to_not have_content("Saved todo list item.")
        expect(page).to have_content("Content is too short")
        todo_item.reload
        expect(todo_item.content).to eq("Item")
      end
  end
end


