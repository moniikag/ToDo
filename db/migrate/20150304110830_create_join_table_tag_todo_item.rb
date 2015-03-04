class CreateJoinTableTagTodoItem < ActiveRecord::Migration
  def change
    create_table :tags_todo_items, id: false do |t|
      t.integer :tag_id 
      t.integer :todo_item_id
      # t.index [:tag_id, :todo_item_id]
      # t.index [:todo_item_id, :tag_id]
    end
  end
end
