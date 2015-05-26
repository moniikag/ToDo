class TodoItemPresenter < BasePresenter

  def completed?
    @model.completed_at.present?
  end

  def tag_list
    @model.tags.map { |t| t.name }.join(", ")
  end

end
