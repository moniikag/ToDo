require 'spec_helper'

describe "Viewing todo items" do
  
  let!(:user) { User.create!(first_name: "example", last_name: "example", email: "example@example.com", password: "password", password_confirmation: "password") }
  let!(:todo_list) { user.todo_lists.create!(title: "Groceries", description: "Grocery list") }

  def log_in
    visit "/user_sessions/new"
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
    expect(page).to have_content("Thanks for logging in!")
  end

  before(:each) { log_in }

    it "displays the title of the todo list" do
      visit "/todo_lists/#{todo_list.id}" 
      expect(page).to have_content(todo_list.title)
    end  

    it "displays item content when a todo list has items" do
      todo_list.todo_items.create!(content: "Apple", deadline: Time.now)
      todo_list.todo_items.create!(content: "Pear", deadline: Time.now)
      
      visit "/todo_lists/#{todo_list.id}"     
      expect(page).to have_content("Apple")
      expect(page).to have_content("Pear")
    end

end


