require 'spec_helper'

describe TodoItem do
  subject { FactoryGirl.create(:todo_item) }

  context ".complete" do
    it "returns proper amount of complete items" do
      expect {
        TodoItem.create!(content: "Item 1", deadline: Time.now, completed_at: Time.now)
      }.to change { TodoItem.complete.count }.by(1)
    end
  end

  context ".incomplete" do
    it "returns proper amount of incomplete items" do
      expect {
        TodoItem.create!(content: "Item 1", deadline: Time.now)
      }.to change{TodoItem.incomplete.count}.by(1)
    end
  end

end
