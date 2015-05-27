class MigrateTagsData < ActiveRecord::Migration

  class OldTag < ActiveRecord::Base
  end

  class OldTagsTodoItems < ActiveRecord::Base
  end

  ActiveRecord::Base.transaction do

    items_with_tags_ids = OldTagsTodoItems.all.map(&:todo_item_id).uniq!

    items_with_tags_ids.each do |item_id|
      item = TodoItem.find(item_id)

      old_tags_ids_for_item = OldTagsTodoItems.where(todo_item_id: item_id).map(&:tag_id)
      old_tags_names_for_item = old_tags_ids_for_item.map! { |old_id| OldTag.where(id: old_id).first.name }

      old_tags_names_for_item.each do |tag_name|
        item.tag_list.add(tag_name)
      end
      item.save!
    end
    print ActsAsTaggableOn::Tagging.last.inspect
    raise "STOP"
  end

end
