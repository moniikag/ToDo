class RenameTagsToOldTags < ActiveRecord::Migration
  def change
    rename_table :tags, :old_tags
  end
end
