require 'spec_helper'
require 'database_cleaner'

describe 'Todo lists: ' do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:todo_list_params) { { title: "Test", description: "Todo list for features test" } }
  let(:todo_item) { FactoryGirl.create(:todo_item, todo_list: todo_list) }
  let(:other_todo_item) { FactoryGirl.create(:todo_item, todo_list: todo_list) }

  before(:each) do
    log_in
  end

  it "displays user's todo lists" do
    visit "/todo_lists"
    expect(page).to have_content(todo_list.title)
  end

  it "allows user to create todo list" do
    visit "/todo_lists"
    within("form#new_todo_list") {
      fill_in "todo_list_title", with: todo_list_params[:title]
      find("input[type=submit]").click
    }
    expect(page).to have_content(todo_list_params[:title])
  end

  it "allows user to show todo list" do
    visit "/todo_lists"
    within("div.list-title") {
      find("a").click
    }
    expect(page).to have_content(todo_list.title)
    expect(current_path).to eq(todo_list_path(todo_list.id))
  end

  it "allows user to search items", :js => true do
    visit "/todo_lists"
    within("form#search-form") {
      fill_in "search", with: todo_item.content
      first('input').native.send_keys(:return)
    }
    within("div#searched-fraze") {
      expect(page).to have_content(todo_item.content.downcase)
    }
    within("div#title-in-search") {
      expect(page).to have_content(todo_list.title)
    }
    expect(current_path).to eq(search_todo_lists_path)
  end

  it "allows user to update todo list title", :js => true do
    visit "/todo_lists/#{todo_list.id}"
    find(".editable-title").click
    within(".editable-title") {
        fill_in "value", with: todo_list_params[:title]
        first('input').native.send_keys(:return)
    }
    expect(page).to have_content(todo_list_params[:title])
  end

  it "allows user to sort items", :js => true do
    other_todo_item
    todo_item
    visit "/todo_lists/#{todo_list.id}"
    within("section#todo_items") {
      expect(first('li')).to have_content(todo_item.content)
      first_li = page.all('li')[0]
      second_li = page.all('li')[1]
      first_li.drag_to second_li
    }
    within("section#todo_items") {
      expect(first('li')).to have_content(other_todo_item.content)
    }
    visit "/todo_lists/#{todo_list.id}" # after reload
    within("section#todo_items") {
      expect(first('li')).to have_content(other_todo_item.content)
    }
  end

  it "allows user to mark all items done", :js => true do
    todo_item
    other_todo_item
    visit "/todo_lists/#{todo_list.id}"
    find("#show-completed").click
    within("div#completed") {
      expect("div#completed").to_not have_content(todo_item.content)
      expect("div#completed").to_not have_content(other_todo_item.content)
    }
    find("#done").click
    alert = page.driver.browser.switch_to.alert
    alert.accept
    within("div#completed") {
      expect(page).to have_content(todo_item.content)
      expect(page).to have_content(other_todo_item.content)
    }
  end

  it "allows user to delete todo list", js: true do
    visit "/todo_lists/#{todo_list.id}"
    expect(page).to have_content(todo_list.title)
    find("#delete-list").click
    alert = page.driver.browser.switch_to.alert
    alert.accept
    expect(current_path).to eq(todo_lists_path)
    expect(page).to_not have_content(todo_list.title)
  end
end
