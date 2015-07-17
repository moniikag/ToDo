class TodoItemPresenter < BasePresenter

  def completed?
    @model.completed_at.present?
  end

  def date
    self.deadline.strftime("%d/%m/%Y") if self.deadline.present?
  end

  def hour
    self.deadline.strftime("%H") if self.deadline.present?
  end

  def minutes
    self.deadline.strftime("%M") if self.deadline.present?
  end

end
