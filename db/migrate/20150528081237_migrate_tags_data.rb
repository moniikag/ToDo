class MigrateTagsData < ActiveRecord::Migration

  class OldTag < ActiveRecord::Base
  end

  class OldTagsTodoItems < ActiveRecord::Base
    belongs_to :tag, class_name: 'OldTag'
  end

  def up
    ActiveRecord::Base.transaction do
      OldTagsTodoItems.includes(:tag).all.each do |relation|
        old_tag = relation.tag
        new_tag = ActsAsTaggableOn::Tag.find_or_create_by(name: old_tag.name)
        ActsAsTaggableOn::Tagging.create!(tag_id: new_tag.id, taggable_id: relation.todo_item_id, taggable_type: "TodoItem", context: "tags")
      end
    end
  end

end

