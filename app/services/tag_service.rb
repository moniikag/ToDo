class TagService

  def initialize(todo_item:, tags: nil)
    @todo_item = todo_item
    @tags_given = tags
  end

  def tag_list
    @todo_item.tags.map { |t| t.name }.join(", ")
  end

  def set_tag_list
    tag_names = @tags_given.split(/\s*,\s*/)
    @todo_item.tags = tag_names.map { |name| Tag.find_or_create_by(name: name) }
  end

end
