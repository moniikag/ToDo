require 'spec_helper'

describe SendReminder do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:todo_item_1) { FactoryGirl.create(:todo_item, todo_list: todo_list) }
  let!(:todo_item_2_urgent) { FactoryGirl.create(:todo_item, todo_list: todo_list, deadline: 1.hour.from_now) }

  let!(:other_todo_list) { FactoryGirl.create(:todo_list, user: user) }
  let!(:other_todo_item_1) { FactoryGirl.create(:todo_item, todo_list: other_todo_list) }
  let!(:other_todo_item_2_urgent) { FactoryGirl.create(:todo_item, todo_list: other_todo_list, deadline: 1.hour.from_now) }

  it "sends email" do
    expect {
      SendReminder.call(current_user: user, todo_lists: user.todo_lists)
    }.to change{ ActionMailer::Base.deliveries.count }.by(1)
  end

  it "returns correct urgent items" do
    SendReminder.call(current_user: user, todo_lists: user.todo_lists)
    mail = ActionMailer::Base.deliveries.last
    expect(mail.body.raw_source).to match(other_todo_item_2_urgent.content)
    expect(mail.body.raw_source).to match(todo_item_2_urgent.content)
    expect(mail.body.raw_source).to_not match(other_todo_item_1.content)
    expect(mail.body.raw_source).to_not match(todo_item_1.content)
  end

end
