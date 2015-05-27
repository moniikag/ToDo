class MigrateTagsData < ActiveRecord::Migration

  class OldTag < ActiveRecord::Base
  end

  class OldTagsTodoItems < ActiveRecord::Base
  end

  ActiveRecord::Base.transaction do

    OldTagsTodoItems.all.each do |relation|
      item = TodoItem.where(id: relation.todo_item_id).first
      old_tag = OldTag.where(id: relation.tag_id).first
      new_tag = Tag.find_or_create_by(name: old_tag.name)
      ActsAsTaggableOn::Tagging.create!(tag_id: new_tag.id, taggable_id: item.id, taggable_type: "#{item.class}", context: "tags")
    end
    print ActsAsTaggableOn::Tagging.all.each.inspect
    print Tag.all.each.inspect

    raise "STOP"
  end

end

