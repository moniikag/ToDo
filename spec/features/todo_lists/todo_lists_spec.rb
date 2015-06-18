require 'spec_helper'
require 'database_cleaner'

describe 'Todo lists: ' do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:todo_list_params) { { title: "Test", description: "Todo list for features test" } }

  before(:each) do
    log_in
    visit "/todo_lists"
  end

  it "displays user's todo lists" do
    expect(page).to have_content(todo_list.title)
  end

  it "allows user to create todo list" do
    within("form#new_todo_list") {
      fill_in "todo_list_title", with: todo_list_params[:title]
      find("input[type=submit]").click
    }
    expect(page).to have_content(todo_list_params[:title])
  end

  it "allows user to show todo list" do
    within("div.list-title") {
      find("a").click
    }
    expect(page).to have_content(todo_list.title)
    expect(current_path).to eq(todo_list_path(todo_list.id))
  end

  it "allows user to edit todo list title", :js => true do
    visit "/todo_lists/#{todo_list.id}"
    find(".editable-title").click
    within(".editable-title") {
        fill_in "value", with: todo_list_params[:title]
        first('input').native.send_keys(:return)
    }
    expect(page).to have_content(todo_list_params[:title])
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
