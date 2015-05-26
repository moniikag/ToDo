require 'spec_helper'

describe ApplicationHelper, :type => :helper do

  let(:todo_item) { FactoryGirl.create(:todo_item) }

  context "#present" do
    it "assings default presenter when only model given" do
      helper.present(todo_item) do |presented_object|
        @object = presented_object
      end
      expect(@object).to be_a(TodoItemPresenter)
    end

    it "assings correct presenter when model & presenter_class given" do
      helper.present(todo_item, TodoItemPresenter) do |presented_object|
        @object = presented_object
      end
      expect(@object).to be_a(TodoItemPresenter)
    end
  end
end
