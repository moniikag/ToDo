class BasePresenter < SimpleDelegator

  def initialize(model,view)
    @model, @view = model, view
    super(@model)
  end

  def template
    @view
  end

end
