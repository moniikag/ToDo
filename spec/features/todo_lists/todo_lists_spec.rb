require 'spec_helper'

describe 'Todo lists: ' do

  let!(:user) { FactoryGirl.build(:user) }

  subject! { FactoryGirl.create(:todo_list, user: user) }
  let(:other_todo_list) { FactoryGirl.create(:todo_list, user: user) }

  let!(:todo_list_params) { { title: "Test", description: "Todo list for features test" } }

  it "displays user's todo lists" do
    log_in
    visit "/todo_lists"
    expect(page).to have_content(subject.title)
  end

  it "allows user to create todo list" do
    log_in
    visit "/todo_lists"
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
    log_in
    visit "/todo_lists"
    expect(page).to have_content("Todo Lists")

    within("#todo_list_#{subject.id}") {click_link "todo-items-index-link"}
    expect(page).to have_content(subject.title)
    expect(current_path).to eq(todo_list_todo_items_path(subject))
  end

  it "allows user to edit todo list" do
    log_in
    visit "/todo_lists"
    expect(page).to have_content("Todo Lists")

    within("#todo_list_#{subject.id}") { click_link "edit-todo-list-link" }
    expect(page).to have_content("Editing Todo List")

    fill_in "todo_list_title", with: todo_list_params[:title]
    fill_in "todo_list_description", with: todo_list_params[:description]
    click_button "save-todo-list"
    expect(page).to have_content("Todo list was successfully updated.")
    expect(page).to have_content(todo_list_params[:title])
  end

  xit "allows user to delete todo list", js: true do
    other_todo_list
    log_in
    sleep(50)
    visit "/todo_lists"
    expect(page).to have_content("Todo Lists")

    print "  ##  Subject: ", subject.title, subject.description, subject.user.email, subject.user.id
    print "  ##  Other_todo_list: ", other_todo_list.title, other_todo_list.description, other_todo_list.user.email, subject.user.id

    within("#todo_list_#{other_todo_list.id}") { click_link "delete-todo-list-link" }
    alert = page.driver.browser.switch_to.alert
    alert.accept
    expect(current_path).to eq(todo_lists_path)
    expect(page).to_not have_content(other_todo_list.title)
  end

  it "allows user to send reminders" do
    log_in
    visit "/todo_lists"
    click_button "send-reminder"
    expect(page).to have_content("Reminder was successfully sent.")
    expect(current_path).to eq(todo_lists_path)
  end

end