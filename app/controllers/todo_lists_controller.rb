class TodoListsController < ApplicationController
  before_action :get_resources

  def index
    authorize TodoList
    @todo_lists = policy_scope(TodoList)
  end

  def new
    authorize TodoList
    @todo_list = current_user.todo_lists.new
  end

  def create
    authorize TodoList
    @todo_list = current_user.todo_lists.new(permitted_attributes(TodoList.new))
    if @todo_list.save
      redirect_to @todo_list, notice: 'Todo list was successfully created.'
    else
      render action: 'new'
    end
  end

  def show
    redirect_to todo_list_todo_items_path(@todo_list)
  end

  def send_reminder
    authorize TodoList
    @todo_lists = policy_scope(TodoList)
    ReminderService.new(current_user: current_user, todo_lists: @todo_lists).send_message
    # @urgent_items = ReminderService.new(todo_lists: @todo_lists).return_urgent_items
    # UserMailer.reminder(@urgent_items, current_user).deliver
    redirect_to todo_lists_path, notice: 'Reminder was successfully sent.'
  end

  def edit
  end

  def update
    if @todo_list.update_attributes(permitted_attributes(@todo_list))
      redirect_to @todo_list, notice: 'Todo list was successfully updated.'
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
