require 'spec_helper'

describe "Deleting todo items" do

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

  it "is successful" do
    log_in
    visit "/todo_lists/#{todo_list.id}/todo_items" 
    within "#todo_item_#{todo_item.id}" do
      click_link "Delete"
    end
    expect(page).to have_content("Todo list item was deleted.")
    expect(TodoItem.count).to eq(0)
  end

end


