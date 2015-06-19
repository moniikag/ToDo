require 'spec_helper'

RSpec.describe TodoListsController do

  let(:user) { FactoryGirl.build(:user) }
  let(:valid_session) { { user_id: user.id } }

  let!(:subject) { FactoryGirl.create(:todo_list, user: user) }
  let(:todo_item) { FactoryGirl.create(:todo_item, todo_list: subject) }

  let(:valid_todo_list_params) { { title: "Another Todo List", description: "Yet another todo list" } }

  let!(:other_todo_list) { FactoryGirl.create(:todo_list) }

  context "GET index: " do
    context "if user not signed in: " do
      it "redirects to new user session path" do
        get :index
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "renders template index & displays todo lists that belong to user" do
        get :index, {}, valid_session
        expect(response).to render_template(:index)
        expect(assigns(:todo_lists)).to eq([subject])
      end
    end
  end

  context "POST create: " do
    context "if user not signed in: " do
      it "redirects to new user session path" do
        post :create, todo_list: valid_todo_list_params
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "given valid params it creates todo_list & redirects to created todo_list" do
        expect {
          post :create, { todo_list: valid_todo_list_params }, valid_session
        }.to change { TodoList.count }.by(1)
      end

      it "given invalid params it doesn't create todo list" do
        valid_todo_list_params.delete(:title)
        expect {
          post :create, { todo_list: valid_todo_list_params }, valid_session
        }.to change { TodoList.count }.by(0)
        expect(response.status).to eq(302)
      end

      it "given extra param it creates todo_list" do
        invalid_todo_list_params = valid_todo_list_params.dup
        invalid_todo_list_params[:extra] = "urgent todo list"
        expect {
          post :create, { todo_list: invalid_todo_list_params }, valid_session
        }.to change { TodoList.count }.by(1)
      end
    end
  end

  context "GET show: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        get :show, id: subject.id
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "displays show view and assigns the todo list" do
        get :show, { id: subject.id }, valid_session
        expect(response).to render_template(:show)
        expect(assigns(:todo_list)).to eq(subject)
      end

      it "raises an error on attempt to show todo list that doesn't belong to the user" do
        expect {
          get :show, { id: other_todo_list.id },valid_session
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "PUT update: " do
    context "if user not signed in: " do
      it "redirects to new user session path" do
        put :update, id: subject.id, todo_list: valid_todo_list_params
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "given valid params it updates todo list & redirects to the todo list" do
        put :update, { id: subject.id, todo_list: valid_todo_list_params }, valid_session
        expect(response).to redirect_to(subject)
      end

      it "raises an error on attempt to update todo list that doesn't belong to the user" do
        expect {
          put :update, { id: other_todo_list.id, todo_list: valid_todo_list_params }, valid_session
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  context "POST prioritize: " do
     context "if user not signed in: " do
      it "redirects to new user session path" do
        post :prioritize, { id: subject.id, ordered_items_ids: [todo_item.id] }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "raises an error on attempt to prioritize todo item from todo list that doesn't belong to the user" do
        expect {
          post :prioritize, { id: other_todo_list.id, ordered_items_ids: [todo_item.id] }, valid_session
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns status 200 after prioritizing list" do
        post :prioritize, { id: subject.id, ordered_items_ids: [todo_item.id] }, valid_session
        expect(response.status).to eq(200)
      end
    end
  end

  context "DELETE destroy: " do
    context "if user not signed in: " do
      it "doesn't destroy todo list & redirects to new user session path" do
        expect {
          delete :destroy, id: subject.id
        }.to change { TodoList.count }.by(0)
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "doesn't destroy todo list & raises an error on attempt to destroy todo list that doesn't belong to the user" do
        expect {
          expect {
            delete :destroy, { id: other_todo_list.id }, valid_session
          }.to raise_error(ActiveRecord::RecordNotFound)
        }.to change { TodoList.count }.by(0)
      end

      it "destroys todo list & redirects to todo_lists" do
        expect {
          delete :destroy, { id: subject.id }, valid_session
        }.to change { TodoList.count }.by(-1)
        expect(response).to redirect_to(todo_lists_url)
      end
    end
  end
end
