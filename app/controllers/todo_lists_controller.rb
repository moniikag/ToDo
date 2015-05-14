class TodoListsController < ApplicationController
  before_action :get_resources

  def index
    authorize TodoList
    @todo_lists = policy_scope(TodoList)
  end

  def new
    authorize TodoList
    @todo_list = TodoList.new
  end

  def create
    authorize TodoList
    @todo_list = policy_scope(TodoList).new(permitted_attributes(TodoList.new))

    respond_to do |format|
      if @todo_list.save
        format.html { redirect_to @todo_list, notice: 'Todo list was successfully created.' }
        format.json { render action: 'show', status: :created, location: @todo_list }
      else
        format.html { render action: 'new' }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    redirect_to todo_list_todo_items_path(@todo_list)
  end

  def send_reminder
    authorize TodoList
    @todo_lists = policy_scope(TodoList)
    @urgent_items = []
    @todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        if (todo_item.deadline.to_time - Time.now - 25.hours) < 0
          @urgent_items << todo_item
        end
      end
    end
    UserMailer.reminder(@urgent_items, current_user).deliver
    redirect_to todo_lists_path, notice: 'Reminder was successfully sent.'
  end

  def edit
  end

  def update
    respond_to do |format|
      if @todo_list.update_attributes(permitted_attributes(@todo_list))
        format.html { redirect_to @todo_list, notice: 'Todo list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo_lists = policy_scope(TodoList)
    if @todo_list.destroy
      respond_to do |format|
        format.html { redirect_to todo_lists_url }
        format.json { head :no_content }
      end
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
