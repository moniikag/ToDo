class TodoItemPresenter < BasePresenter

  def completed?
    @model.completed_at.present?
  end

end
