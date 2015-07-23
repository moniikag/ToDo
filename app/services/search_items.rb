class SearchItems
  def self.call(lists:, items:, searched_fraze:)
    todo_items_by_tag = items.tagged_with(searched_fraze)
    todo_items_by_content = lists.flat_map(&:todo_items)
      .select { |item| item.content.downcase.start_with?(searched_fraze)}

    todo_items = (todo_items_by_content + todo_items_by_tag).flatten
      .map { |item| TodoItemPresenter.new(item) }
      .group_by{ |item| item.todo_list }
  end
end
