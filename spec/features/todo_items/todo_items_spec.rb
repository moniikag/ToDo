require 'spec_helper'
require 'database_cleaner'

describe 'Todo items: ' do
 
  let!(:user) { FactoryGirl.build(:user) }

  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  subject! { FactoryGirl.create(:todo_item, todo_list: todo_list)}

  let!(:other_todo_item) { FactoryGirl.create(:todo_item, todo_list: todo_list)}

  let(:todo_item_params) { { 
    content: "Test", year: "2015", month: "May", day: "30", hour: "10", minutes: "30", tag: "fee" 
    } }

  before(:each) do
    log_in
    visit "/todo_lists/#{todo_list.id}/todo_items"
  end

  it "displays user's todo items" do
    expect(page).to have_content(subject.content)
  end

  it "set item's class 'urgent' if item's deadline is in less than 24 h" do
    subject.update_attribute("deadline", 5.hours.from_now)
    visit "/todo_lists/#{todo_list.id}/todo_items"
    within("#todo_item_#{subject.id}") { expect(page).to have_selector("td.urgent") }
  end

  it "allows user to create todo item & add tag to it" do
    expect(page).to have_content(todo_list.title)
    click_link "new-todo-item-link"
    expect(current_path).to eq(new_todo_list_todo_item_path(todo_list))

    fill_in "todo_item_content", with: todo_item_params[:content]
    select todo_item_params[:year], from: "todo_item_deadline_1i" 
    select todo_item_params[:month], from: "todo_item_deadline_2i" 
    select todo_item_params[:day], from: "todo_item_deadline_3i" 
    select todo_item_params[:hour], from: "todo_item_deadline_4i" 
    select todo_item_params[:minutes], from: "todo_item_deadline_5i" 
    fill_in "todo_item_tag_list", with: todo_item_params[:tag]

    click_button "save-todo-item"
    expect(current_path).to eq(todo_list_todo_items_path(todo_list))
    expect(page).to have_content("Added todo list item.")
    expect(page).to have_content(todo_item_params[:title], todo_item_params[:tag])
  end

  it "allows user to edit todo item" do
    expect(page).to have_content(todo_list.title)

    within("#todo_item_#{subject.id}") {click_link "Edit"}
    expect(page).to have_content("Editing Todo List Item")

    fill_in "todo_item_content", with: "New content"
    select "25", from: "todo_item_deadline_3i"
    fill_in "todo_item_tag_list", with: "New Tag"

    click_button "save-todo-item"
    expect(current_path).to eq(todo_list_todo_items_path(todo_list))
    expect(page).to have_content("Updated todo list item.")
    expect(page).to have_content("New content", "25", "New Tag")
  end

  it "allows user to add tag to existing item" do
    expect(page).to have_content(todo_list.title)

    within("#todo_item_#{subject.id}") {click_link "Edit"}
    expect(current_path).to eq(edit_todo_list_todo_item_path(todo_list, subject.id))
    fill_in "todo_item_tag_list", with: todo_item_params[:tag]
    click_button "save-todo-item"

    expect(current_path).to eq(todo_list_todo_items_path(todo_list))
    expect(page).to have_content("Updated todo list item.")
    expect(page).to have_content(todo_item_params[:tag])
  end

  it "allows user to mark item complete" do
    within("#todo_item_#{subject.id}") { click_link "mark-complete-link" }
    within("#todo_item_#{subject.id}") { expect(page).to_not have_link("mark-complete-link") }
  end

  it "allows user to delete todo item", js: true do
    expect(page).to have_content(todo_list.title)

    within("#todo_item_#{other_todo_item.id}") {click_link "delete-todo-item-link"}
    alert = page.driver.browser.switch_to.alert
    alert.accept
    expect(current_path).to eq(todo_list_todo_items_path(todo_list))
    expect(page).to_not have_content(other_todo_item.content)
  end

end