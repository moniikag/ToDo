class DropTableOldTagsAndTableOldTagsTodoItems < ActiveRecord::Migration
  def up
    drop_table :old_tags
    drop_table :old_tags_todo_items
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
