require 'spec_helper'
require 'database_cleaner'

describe 'Todo items: ' do

  let!(:user) { FactoryGirl.create(:user) }

  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  subject! { FactoryGirl.create(:todo_item, todo_list: todo_list)}

  let(:todo_item_params) { {
    content: "Test", date: "30/05/2015", hour: "10", minutes: "30", tag: "fee"
    } }

  before(:each) do
    log_in
    visit "/todo_lists/#{todo_list.id}"
    expect(page).to have_content(todo_list.title)
  end

  it "displays user's todo items" do
    expect(page).to have_content(subject.content)
  end

  it "set item's class 'urgent' if item's deadline is in less than 24 h" do
    subject.update_attribute("deadline", 5.hours.from_now)
    visit "/todo_lists/#{todo_list.id}"
    within("section#todo_items") {
      within(first("li")) {
        expect(page).to have_selector("div.urgent")
      }
    }
  end

  it "allows user to create todo item" do
    expect(page).to have_content(todo_list.title)
    within("form#new_todo_item") {
      fill_in "todo_item_content", with: todo_item_params[:content]
      find("input[type=submit]").click
    }
    expect(current_path).to eq(todo_list_path(todo_list.id))
    expect(page).to have_content(todo_item_params[:title])
  end

  it "allows user to edit todo item" do
    within(".details") {
      fill_in "todo_item_content", with: todo_item_params[:content]
      fill_in "datepicker_#{subject.id}", with: todo_item_params[:date]
      find("input[type=submit]").click
    }
    expect(current_path).to eq(todo_list_path(todo_list.id))
    expect(page).to have_content("Updated todo list item.")
    expect(page).to have_content(todo_item_params[:content], todo_item_params[:date])
  end

  it "allows user to add tag to existing item" do
    within(".details") {
      fill_in "todo_item_tag_list", with: todo_item_params[:tag]
      find("input[type=submit]").click
    }
    expect(current_path).to eq(todo_list_path(todo_list.id))
    expect(page).to have_content("Updated todo list item.")
    expect(page).to have_content(todo_item_params[:tag])
  end

  xit "allows user to mark item complete", js: true do
    within("#completed", :visible => false) {
      expect(page).to_not have_content(subject.content)
    }
    within("div.for-checkbox") {
      find(:css, "label:before").click
    }
    expect(subject.completed_at).to_not be_nil
    within("#completed", :visible => false) {
      expect(page).to have_content(subject.content)
    }
  end

  it "allows user to delete todo item", js: true do
    expect(page).to have_content(subject.content)
    within("#todo_items") {
      first('li').hover
      first('.show').click
    }
    within(".details") {
      find("a").click
    }
    alert = page.driver.browser.switch_to.alert
    alert.accept
    expect(page).to_not have_content(subject.content)
  end
end
