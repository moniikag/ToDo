class TodoItemsController < ApplicationController

  before_action :get_resources

  def index
    @todo_items = policy_scope(@todo_list.todo_items)
    @todo_items.map! { |todo_item| TodoItemPresenter.new(todo_item) }
  end

  def new
    @todo_item = @todo_list.todo_items.new
  end

  def create
    @todo_item = @todo_list.todo_items.new(permitted_attributes(TodoItem.new))
    if @todo_item.save
      flash[:success] = "Added todo list item."
      redirect_to todo_list_todo_items_path
    else
      flash[:error] = "There was a problem adding that todo list item."
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @todo_item.update_attributes(permitted_attributes(@todo_item))
      flash[:success] = "Updated todo list item."
      redirect_to todo_list_todo_items_path
    else
      flash[:error] = "That todo item could not be saved."
      render action: :edit
    end
  end

  def complete
    @todo_item.update_attribute(:completed_at, Time.now)
    redirect_to todo_list_todo_items_path, notice: "Todo item marked as complete."
  end

  def destroy
    if @todo_item.destroy
      flash[:success] = "Todo list item was deleted."
    else
      flash[:error] = "Todo list item could not be deleted."
    end
    redirect_to todo_list_todo_items_path
  end

  private
  def get_resources
    @todo_list = policy_scope(TodoList).find(params[:todo_list_id])
    @todo_item = policy_scope(@todo_list.todo_items).find(params[:id]) if params[:id]
    authorize @todo_item || TodoItem
  end

end
