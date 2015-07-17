class TodoItemsController < ApplicationController
  include TodoItemsHelper

  before_action :get_resources

  def show
  end

  def create
    @todo_item = @todo_list.todo_items.new(permitted_attributes(TodoItem.new))
    unless @todo_item.save
      flash[:error] = "There was a problem adding that todo list item."
    end
    redirect_to todo_list_path(@todo_list)
  end

  def update
    @todo_item.deadline = deadline_from_form unless deadline_from_form==nil
    respond_to do |format|
      if @todo_item.update_attributes(permitted_attributes(@todo_item))
        format.html {
          flash[:success] = "Updated todo list item."
          redirect_to todo_list_path(@todo_item.todo_list_id)
        }
        format.json { render :json => @todo_item }
      else
        format.html {
          flash[:error] = "That todo item could not be saved."
          redirect_to todo_list_path(@todo_item.todo_list_id)
        }
        format.json {}
      end
    end
  end

  def complete
    authorize @todo_item
    if params[:completed] == "true"
      @todo_item.update_attributes(completed_at: Time.now, priority: nil)
    else
      @todo_item.update_attributes(completed_at: nil, priority: 0)
    end
    render nothing: true
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
