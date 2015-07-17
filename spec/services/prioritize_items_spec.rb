require 'spec_helper'

describe PrioritizeItems do

  let!(:todo_list) { FactoryGirl.create(:todo_list) }
  let!(:todo_item) { FactoryGirl.create(:todo_item, todo_list: todo_list) }
  let(:other_todo_item) { FactoryGirl.create(:todo_item, todo_list: todo_list) }
  let(:ordered_items_ids) { ["2", "1", ""]}

  it "updates item's priority" do
    expect(todo_item.priority).to eq(nil)
    expect(other_todo_item.priority).to eq(nil)
    PrioritizeItems.call(items: todo_list.todo_items, ids_in_order: ordered_items_ids)
    todo_item.reload
    other_todo_item.reload
    expect(todo_item.priority).to eq(2)
    expect(other_todo_item.priority).to eq(1)
  end
end
