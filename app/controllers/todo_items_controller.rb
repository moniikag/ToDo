class TodoItemsController < ApplicationController
  include TodoItemsHelper

  before_action :get_resources, except: [:complete]

  # def index
  #   @todo_items = policy_scope(@todo_list.todo_items)
  #   @todo_items_complete = @todo_items.complete.map! { |todo_item| TodoItemPresenter.new(todo_item) }
  #   @todo_items_incomplete = @todo_items.incomplete.map! { |todo_item| TodoItemPresenter.new(todo_item) }
  # end

  def new
    @todo_item = @todo_list.todo_items.new
  end

  def create
    @todo_item = @todo_list.todo_items.new(permitted_attributes(TodoItem.new))
    unless @todo_item.save
      flash[:error] = "There was a problem adding that todo list item."
    end
    redirect_to todo_list_path(@todo_list)
  end

  # def show
  # end

  def edit
  end

  def update
    @todo_item.deadline = deadline_from_form unless deadline_from_form==nil
    if @todo_item.update_attributes(permitted_attributes(@todo_item))
      flash[:success] = "Updated todo list item."
      redirect_to todo_list_path(@todo_item.todo_list_id)
    else
      flash[:error] = "That todo item could not be saved."
      render action: :edit
    end
  end

  def complete
    @todo_item = TodoItem.find(params[:id])
    authorize @todo_item
    if params[:completed] == "true"
      @todo_item.update_attribute(:completed_at, Time.now)
    else
      @todo_item.update_attribute(:completed_at, nil)
    end
  end

  def destroy
    if @todo_item.destroy
      flash[:success] = "Todo list item was deleted."
    else
      flash[:error] = "Todo list item could not be deleted."
    end
    redirect_to todo_list_path(@todo_list)
  end

  private
  def get_resources
    @todo_list = policy_scope(TodoList).find(params[:todo_list_id])
    @todo_item = policy_scope(@todo_list.todo_items).find(params[:id]) if params[:id]
    authorize @todo_item || TodoItem
  end

end
