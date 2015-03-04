class CreateJoinTableTagTodoItem < ActiveRecord::Migration
  def change
    create_table :tags_todo_items, id: false do |t|
      t.integer :tag_id
      t.integer :todo_item_id
    end


      add_index :tags_todo_items, :tag_id 
      add_index :tags_todo_items, :todo_item_id

      # t.index [:tag_id, :todo_item_id]
      # t.index [:todo_item_id, :tag_id]
    
  end
end
