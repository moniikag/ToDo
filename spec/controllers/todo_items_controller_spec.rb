require 'spec_helper'

Rspec.describe TodoItemsController do
  fixtures :all
  subject { todo_items(:todo_item_1) }
  let(:other_todo_item) { todo_items(:todo_item_2) }
  let(:valid_todo_item_params) { content: "Yet another content", deadline: "2015-05-25 10:52:00"}

  let(:user) { users(:john) }
  let(:valid_session) { { user_id: user.id } }


end