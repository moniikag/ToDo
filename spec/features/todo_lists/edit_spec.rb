require 'spec_helper'

describe "Editing todo lists" do

  let!(:user) { User.create!(first_name: "example", last_name: "example", email: "example@example.com", password: "password", password_confirmation: "password") }
  let!(:todo_list) { user.todo_lists.create!(title: "Groceries", description: "Grocery list") }

  before(:each) {log_in}

  def update_todo_list(options={})
    options[:title] ||= "New Title"
    options[:description] ||= "New Description."

    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
      click_link "Edit"
    end
    fill_in "Title", with: options[:title]
    fill_in "Description", with: options[:description]
    click_button "Update Todo list"
  end

  def log_in
    visit "/user_sessions/new"
    fill_in "email", with: user.email
    fill_in "password", with: user.password
    click_button "Log In"
    expect(page).to have_content("Thanks for logging in!")
  end

  it "updates a todo list successfully with correct information" do #doesn't work
    update_todo_list
    expect(page).to have_content("Todo list was successfully updated")
    expect(page).to have_content("New Title")
    expect(page).to_not have_content("Groceries")
    # expect(TodoList.all).to eq([])
    expect(todo_list.title).to eq("New Title")
    expect(todo_list.title).to eq("New Description")
  end

  it "displays an error with no title" do
    update_todo_list title: ""
    expect(todo_list.title).to eq("Groceries")
    expect(page).to have_content("error")
    expect(page).to have_content("Title can't be blank")
  end

  it "displays an error with too short a title" do
    update_todo_list title: "hi"
    expect(page).to have_content("error")
    expect(page).to have_content("Title is too short")
    expect(todo_list.title).to eq("Groceries")
  end

  it "displays an error with no description" do
    update_todo_list description: ""
    expect(page).to have_content("error")
    expect(page).to have_content("Description can't be blank")
    expect(todo_list.description).to eq("Grocery list")
  end

  it "displays an error with too short description" do
    update_todo_list description: "hi"
    expect(page).to have_content("error")
    expect(page).to have_content("Description is too short")
    expect(todo_list.description).to eq("Grocery list")
  end
end
