class MigrateTagsData < ActiveRecord::Migration

  class OldTag < ActiveRecord::Base
  end

  class OldTagsTodoItems < ActiveRecord::Base
  end

  ActiveRecord::Base.transaction do
    OldTag.all.each do |old_tag|
      tag = Tag.create!(:name => old_tag.name)

      old_relations_for_the_tag = OldTagsTodoItems.where(tag_id: old_tag.id)
      old_relations_for_the_tag.each do |relation|
        todo_item = TodoItem.find(relation.todo_item_id)
        todo_item.tag_list = todo_item.tag_list + [old_tag.name]
        todo_item.save!
      end
    end

    TodoItem.all.each do |ti|
      puts ti.tag_list.inspect
    end

    raise "STOP"
  end

end
