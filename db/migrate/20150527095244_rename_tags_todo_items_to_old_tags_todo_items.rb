class RenameTagsTodoItemsToOldTagsTodoItems < ActiveRecord::Migration
  def change
    rename_table :tags_todo_items, :old_tags_todo_items
  end
end
