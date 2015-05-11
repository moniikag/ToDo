require 'spec_helper'
require 'database_cleaner'

describe 'Todo lists: ' do

  let!(:user) { FactoryGirl.build(:user) }

  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:other_todo_list) { FactoryGirl.create(:todo_list, user: user) }

  let!(:todo_list_params) { { title: "Test", description: "Todo list for features test" } }

  before(:each) do
    log_in
    visit "/todo_lists"
  end

  it "displays user's todo lists" do
    expect(page).to have_content(todo_list.title)
  end

  it "allows user to create todo list" do
    expect(page).to have_content("Todo Lists")

    click_link "new-todo-list-link"
    expect(page).to have_content("New Todo List")

    fill_in "todo_list_title", with: todo_list_params[:title]
    fill_in "todo_list_description", with: todo_list_params[:description]
    click_button "save-todo-list"
    expect(page).to have_content("Todo list was successfully created.")
    expect(page).to have_content(todo_list_params[:title])
  end

  it "allows user to show todo list" do
    expect(page).to have_content("Todo Lists")

    within("#todo_list_#{todo_list.id}") {click_link "todo-items-index-link"}
    expect(page).to have_content(todo_list.title)
    expect(current_path).to eq(todo_list_todo_items_path(todo_list))
  end

  it "allows user to edit todo list" do
    expect(page).to have_content("Todo Lists")

    within("#todo_list_#{todo_list.id}") { click_link "edit-todo-list-link" }
    expect(page).to have_content("Editing Todo List")

    fill_in "todo_list_title", with: todo_list_params[:title]
    fill_in "todo_list_description", with: todo_list_params[:description]
    click_button "save-todo-list"
    expect(page).to have_content("Todo list was successfully updated.")
    expect(page).to have_content(todo_list_params[:title])
  end

  it "allows user to delete todo list", js: true do
    expect(page).to have_content("Todo Lists")
    within("#todo_list_#{other_todo_list.id}") { click_link "delete-todo-list-link" }
    alert = page.driver.browser.switch_to.alert
    alert.accept
    expect(current_path).to eq(todo_lists_path)
    expect(page).to_not have_content(other_todo_list.title)
  end

  it "allows user to send reminders" do
    click_button "send-reminder"
    expect(page).to have_content("Reminder was successfully sent.")
    expect(current_path).to eq(todo_lists_path)
  end

end