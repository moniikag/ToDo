require 'spec_helper'

describe TodoItemPresenter do

  let!(:todo_item) { FactoryGirl.create(:todo_item) }

  before(:each) {
    @todo_item = TodoItemPresenter.new(todo_item)
  }

  context "#completed?" do
    it "returns true if todo_item is completed" do
      @todo_item.completed_at = Time.now
      expect(@todo_item.completed?).to eq(true)
    end

    it "returns false if todo_item is not completed" do
      @todo_item.completed_at = nil
      expect(@todo_item.completed?).to eq(false)
    end
  end

end
