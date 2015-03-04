class CreateJoinTableTagTodoItem < ActiveRecord::Migration
  def change
    create_join_table :tags, :todo_items do |t|
      # t.index [:tag_id, :todo_item_id]
      # t.index [:todo_item_id, :tag_id]
    end
  end
end
