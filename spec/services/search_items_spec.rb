require 'spec_helper'

describe SearchItems do

  let!(:user) { FactoryGirl.create(:user) }

  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:todo_item_1) { FactoryGirl.create(:todo_item, todo_list: todo_list) }
  let!(:todo_item_2) { FactoryGirl.create(:todo_item, todo_list: todo_list) }

  let!(:other_todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:other_todo_item_1) { FactoryGirl.create(:todo_item, todo_list: other_todo_list) }
  let!(:other_todo_item_2) { FactoryGirl.create(:todo_item, todo_list: other_todo_list) }

  it "assigns correct search results" do
    todo_item_1.update_attribute(:content, "important item")
    other_todo_item_2.update_attribute(:tag_list, "important, other")
    search_results = SearchItems.call(lists: user.todo_lists, items: TodoItem, searched_fraze: "important")
    expect(search_results).to eq(todo_list => [todo_item_1], other_todo_list => [other_todo_item_2])
  end
end
