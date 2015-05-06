require 'spec_helper'

RSpec.describe TodoItemsController do
  fixtures :all
  subject { todo_items(:todo_item_1) }
  let(:other_todo_item) { todo_items(:todo_item_2) }
  let(:valid_todo_item_params) { { content: "Yet another content", deadline: "2015-05-25 10:52:00"} }

  let(:todo_list) { todo_lists(:todo_list_1) }
  let(:other_todo_list) { todo_lists(:todo_list_2) }

  let(:user) { users(:john) }
  let(:valid_session) { { user_id: user.id } }

  context "GET index: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        get :index, use_route: :todo_lists
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "renders tempate index & assigns todo items that belong to user" do
        get :index, { use_route: :todo_lists , todo_list_id: subject.todo_list_id }, valid_session
        expect(response).to render_template(:index)
        expect(assigns(:todo_items)).to eq([subject])
      end
    end
  end

  context "GET new: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        get :new, todo_list_id: subject.todo_list_id
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "renders template new and assigns new todo item" do
        get :new, { todo_list_id: subject.todo_list_id }, valid_session
        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
        expect(assigns(:todo_item)).to be_a_new(TodoItem)
      end
    end
  end

  context "POST create: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        post :create, { todo_list_id: subject.todo_list_id, todo_item: valid_todo_item_params }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "given valid params creates todo_item and redirects to todo_items" do
        expect {
          post :create, { todo_list_id: subject.todo_list_id, todo_item: valid_todo_item_params }, valid_session
        }.to change { TodoItem.count }.by(1)
        expect(response).to redirect_to(todo_list_todo_items_path)
      end

      it "given invalid params doesn't create todo_item and renders template new" do
        valid_todo_item_params.delete(:content)
        expect {
          post :create, { todo_list_id: subject.todo_list_id, todo_item: valid_todo_item_params }, valid_session
        }.to change { TodoItem.count }.by(0)
        expect(response).to render_template(:new)
      end

      it "given extra param creates todo_item and redirects to todo_items" do
        valid_todo_item_params[:extra] = "my todo item"
        expect {
          post :create, { todo_list_id: subject.todo_list_id, todo_item: valid_todo_item_params }, valid_session
        }.to change { TodoItem.count }.by(1)
        expect(response).to redirect_to(todo_list_todo_items_path)
      end      
    end
  end

  context "GET edit: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        get :edit, { todo_list_id: subject.todo_list_id, id: subject.id }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "renders template edit and assigns proper todo item" do
        get :edit, { todo_list_id: subject.todo_list_id, id: subject.id }, valid_session
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(assigns(:todo_item)).to eq(subject)
      end

      it "raises an error on attempt to edit todo item that doesn't belong to the user" do  
        expect {
          get :edit, { todo_list_id: other_todo_list.id, id: other_todo_item.id }, valid_session
        }.to raise_error()
      end
    end
  end

  context "PUT update: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        put :update, { todo_list_id: subject.todo_list_id, id: subject.id, todo_item: valid_todo_item_params }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "given valid params it updates todo item & redirects to todo list" do
        put :update, { todo_list_id: subject.todo_list_id, id: subject.id, todo_item: valid_todo_item_params }, valid_session
        expect(response).to redirect_to(todo_list_todo_items_path)
      end

      it "given invalid params renders template edit & assings the todo item" do
        valid_todo_item_params[:content] = ''
        put :update, { todo_list_id: subject.todo_list_id, id: subject.id, todo_item: valid_todo_item_params }, valid_session
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(assigns(:todo_item)).to eq(subject)
      end

      it "raises an error on attempt to update todo item that doesn't belong to the user" do  
        expect {
          put :update, { todo_list_id: other_todo_list.id, id: other_todo_item.id, todo_item: valid_todo_item_params}, valid_session
        }.to raise_error()
      end
    end
  end

  context "DELETE destroy: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        delete :destroy, { todo_list_id: subject.todo_list_id, id: subject.id }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "destroys todo item & redirects to todo list" do
        expect {
          delete :destroy, { todo_list_id: subject.todo_list_id, id: subject.id }, valid_session
        }.to change { TodoItem.count }.by(-1)
        expect(response).to redirect_to(todo_list_todo_items_path)
      end

      it "doesn't destroy todo item & raises an error on attempt to destroy todo item that doesn't belong to the user" do  
        expect {
          expect {
            delete :destroy, { todo_list_id: other_todo_list.id, id: other_todo_item.id }, valid_session
          }.to raise_error()
        }.to change { TodoItem.count }.by(0)
      end
    end
  end

end