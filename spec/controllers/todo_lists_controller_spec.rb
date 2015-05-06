require 'spec_helper'

RSpec.describe TodoListsController do
  fixtures :all
  subject { todo_lists(:todo_list_1) }
  let(:other_todo_list) { todo_lists(:todo_list_2) }
  let(:valid_todo_list_params) { { title: "Another Todo List", description: "Yet another todo list" } }

  let(:user) { users(:john) }
  let(:valid_session) { { user_id: user.id } }

  context "GET index: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        get :index
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "renders template index & displays todo lists that belong to user" do
        get :index, {}, valid_session
        expect(assigns(:todo_lists)).to eq([subject])
        expect(response).to render_template(:index)
      end
    end
  end

  context "GET new: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        get :new
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "renders template new" do
        get :new, { }, valid_session
        expect(response.status).to eq(200)
        expect(assigns(:todo_list)).to be_a_new(TodoList)
        expect(response).to render_template(:new)
      end
    end
  end

  context "POST create: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        post :create, todo_list: valid_todo_list_params
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "given valid params it creates todo_list and redirects to created todo_list" do
        expect {
          post :create, { todo_list: valid_todo_list_params }, valid_session
        }.to change { TodoList.count }.by(1)
        todo_list = user.todo_lists.where("title = 'Another Todo List'").first
        expect(response).to redirect_to(todo_list)
      end

      it "given invalid params it doesn't create todo list and it renders template new" do
        valid_todo_list_params.delete(:title)
        expect {
          post :create, { todo_list: valid_todo_list_params }, valid_session
        }.to change { TodoList.count }.by(0)
        expect(response).to render_template(:new)
      end

      it "given extra param it creates todo_list and redirects to created todo_list" do
        valid_todo_list_params[:extra] = "urgent todo list"
        expect {
          post :create, { todo_list: valid_todo_list_params }, valid_session
        }.to change { TodoList.count }.by(1)
        todo_list = user.todo_lists.where("title = 'Another Todo List'").first
        expect(response).to redirect_to(todo_list)
      end
    end
  end
  
  context "POST send_reminder: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        post :send_reminder
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do  ########### DEPRECATION FROM HERE
      it "sends reminder" do
        post :send_reminder, {}, valid_session
        expect(response).to redirect_to(todo_lists_path)
      end
    end
  end
  
  context "GET edit: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        get :edit, id: subject.id
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "renders template edit and assigns proper todo list" do
        get :edit, { id: subject.id }, valid_session
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(assigns(:todo_list)).to eq(subject)
      end

      it "raises an error on attempt to edit todo list that doesn't belong to the user" do  ################# ?
        expect {
          get :edit, { id: other_todo_list.id },valid_session
        }.to raise_error()
      end
    end
  end
  
  context "PUT update: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        put :update, id: subject.id, todo_list: valid_todo_list_params
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "given valid params it updates todo list & redirects to the todo list" do
        put :update, { id: subject.id, todo_list: valid_todo_list_params }, valid_session
        expect(response).to redirect_to(subject)
      end

      it "given invalid params renders template edit & assings the todo list" do
        valid_todo_list_params[:title] = ''
        put :update, { id: subject.id, todo_list: valid_todo_list_params }, valid_session
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(assigns(:todo_list)).to eq(subject)
      end

      it "raises an error on attempt to update todo list that doesn't belong to the user" do  
        expect {
          put :update, { id: other_todo_list.id, todo_list: valid_todo_list_params }, valid_session
        }.to raise_error()
      end
    end
  end
  
  context "DELETE destroy: " do
    context "if user not signed in" do
      it "doesn't destroy todo list & redirects to new user session path" do
        expect {
          delete :destroy, id: subject.id
        }.to change { TodoList.count }.by(0)
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "destroys todo list & redirects to todo_lists" do
        expect {
          delete :destroy, { id: subject.id }, valid_session
        }.to change { TodoList.count }.by(-1)
        expect(response).to redirect_to(todo_lists_url)
      end

      it "doesn't destroy todo list & raises an error on attempt to destroy todo list that doesn't belong to the user" do  
        expect {
          expect {
            delete :destroy, { id: other_todo_list.id }, valid_session
          }.to raise_error()
        }.to change { TodoList.count }.by(0)
      end
    end
  end
  
end