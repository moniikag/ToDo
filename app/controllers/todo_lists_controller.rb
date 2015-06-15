class TodoListsController < ApplicationController
  before_action :get_resources

  def index
    authorize TodoList
    @todo_lists = policy_scope(TodoList)
  end

  def search
    authorize TodoList
    @todo_lists = policy_scope(TodoList)
    @search = params[:search].downcase

    todo_items_by_tag = policy_scope(TodoItem).tagged_with(@search)
    todo_items_by_content = policy_scope(TodoList).flat_map(&:todo_items)
      .select { |item| item.content.downcase.start_with?(@search)}

    @todo_items = (todo_items_by_content + todo_items_by_tag).flatten
      .map { |item| TodoItemPresenter.new(item) }
      .group_by{ |item| item.todo_list }
  end

  def new
    authorize TodoList
    @todo_list = current_user.todo_lists.new
  end

  def create
    authorize TodoList
    @todo_list = current_user.todo_lists.new(permitted_attributes(TodoList.new))
    if @todo_list.save
      redirect_to @todo_list
    else
      render action: 'new'
    end
  end

  def show
    @todo_lists = policy_scope(TodoList)
    @todo_items_complete = @todo_list.todo_items.complete.map { |todo_item| TodoItemPresenter.new(todo_item) }
    @todo_items_incomplete = @todo_list.todo_items.incomplete.map { |todo_item| TodoItemPresenter.new(todo_item) }
  end

  def send_reminder
    authorize TodoList
    @todo_lists = policy_scope(TodoList)
    SendReminder.call(current_user: current_user, todo_lists: @todo_lists)
    redirect_to todo_lists_path, notice: 'Reminder was successfully sent.'
  end

  def edit
    @todo_lists = policy_scope(TodoList)
  end

  def update
    if @todo_list.update_attributes(permitted_attributes(@todo_list))
      respond_to do |format|
        format.html { redirect_to @todo_list, notice: 'Todo list was successfully updated.' }
        format.json { render json: @todo_list }
      end
    else
      render action: 'edit'
    end
  end

  def destroy
    @todo_lists = policy_scope(TodoList)
    if @todo_list.destroy
      redirect_to todo_lists_url
    else
      redirect_to root_path
    end
  end

  private
  def get_resources
    @todo_list = policy_scope(TodoList).find(params[:id]) if params[:id]
    if @todo_list
      authorize @todo_list
    else
      authorize TodoList
    end
  end

end
