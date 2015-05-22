require 'spec_helper'

describe TodoItemPresenter do

  let!(:todo_item) { FactoryGirl.create(:todo_item) }

  before(:each) {
    view_context = 'view'
    @presenter = TodoItemPresenter.new(todo_item, view_context)
  }

  context "#completed?" do
    it "returns true if todo_item is completed" do
      todo_item.completed_at = Time.now
      expect(@presenter.completed?).to eq(true)
    end

    it "returns false if todo_item is not completed" do
      todo_item.completed_at = nil
      expect(@presenter.completed?).to eq(false)
    end
  end

  context "#tag_list" do
    it "displays one tag properly" do
      todo_item.tags.new(name: "urgent")
      expect(@presenter.tag_list).to eq("urgent")
    end

    it "displays two tags properly" do
      todo_item.tags.new(name: "urgent")
      todo_item.tags.new(name: "important")
      expect(@presenter.tag_list).to eq("urgent, important")
    end

    it "displays three tags properly" do
      todo_item.tags.new(name: "urgent")
      todo_item.tags.new(name: "important")
      todo_item.tags.new(name: "fee")
      expect(@presenter.tag_list).to eq("urgent, important, fee")
    end
  end

end
