class TodoListsController < ApplicationController
  before_action :set_todo_list, only: [:show, :edit, :update, :destroy]

  # GET /todo_lists
  # GET /todo_lists.json
  def index
    @todo_lists = current_user.todo_lists
  end

  # GET /todo_lists/new
  def new
    @todo_list = TodoList.new
  end

  # POST /todo_lists
  # POST /todo_lists.json
  def create
    @todo_list = current_user.todo_lists.new(todo_list_params)

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
    @todo_lists = current_user.todo_lists
    @urgent_items = []
    @todo_lists.each do |todo_list|
      todo_list.todo_items.each do |todo_item|
        if (todo_item.deadline.to_time - Time.now - 25.hours) < 0
          @urgent_items << todo_item
        end
      end
    end
    UserMailer.reminder(@urgent_items).deliver
    redirect_to todo_lists_path
  end
  # GET /todo_lists/1/edit
  def edit
  end

  # PATCH/PUT /todo_lists/1
  # PATCH/PUT /todo_lists/1.json
  def update
    respond_to do |format|
      if @todo_list.update(todo_list_params)
        format.html { redirect_to @todo_list, notice: 'Todo list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_lists/1
  # DELETE /todo_lists/1.json
  def destroy
    @todo_lists = current_user.todo_lists
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
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_list
      @todo_list = current_user.todo_lists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_list_params
      params.require(:todo_list).permit(:title, :description)
    end
end
