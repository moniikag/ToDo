require 'spec_helper'

describe ReminderService do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:todo_item_1) { FactoryGirl.create(:todo_item, todo_list: todo_list) }
  let!(:todo_item_2_urgent) { FactoryGirl.create(:todo_item, todo_list: todo_list, deadline: 1.hour.from_now) }

  let!(:other_todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:other_todo_item_1) { FactoryGirl.create(:todo_item, todo_list: other_todo_list) }
  let!(:other_todo_item_2_urgent) { FactoryGirl.create(:todo_item, todo_list: other_todo_list, deadline: 1.hour.from_now) }

  it "returns correct urgent items" do
    expect(ReminderService.new(todo_lists: user.todo_lists).return_urgent_items).to eq([other_todo_item_2_urgent, todo_item_2_urgent])
  end

end
