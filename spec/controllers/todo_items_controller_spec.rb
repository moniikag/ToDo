require 'spec_helper'

RSpec.describe TodoItemsController do

  let(:user) { FactoryGirl.build(:user) }
  let(:valid_session) { { user_id: user.id } }

  let(:todo_list) { FactoryGirl.create(:todo_list, user: user) }

  let!(:subject) { FactoryGirl.create(:todo_item, todo_list: todo_list) }
  let(:valid_todo_item_params) { { content: "Yet another content", deadline: "2015-05-25 10:52:00" } }

  let(:other_todo_list) { FactoryGirl.create(:todo_list) }
  let(:other_todo_item) { FactoryGirl.create(:todo_item, todo_list: other_todo_list) }

  let(:invited_todo_item) { FactoryGirl.create(:todo_item) }
  let(:invitation) { FactoryGirl.create(:invitation, todo_list: invited_todo_item.todo_list, invited_user_email: user.email)}

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
        expect(response).to redirect_to(todo_list_path(subject.todo_list_id))
      end

      it "raises an error on attempt to create todo item in todo list that doesn't belong to the user" do
        expect {
          post :create, { todo_list_id: other_todo_list.id, todo_item: valid_todo_item_params }, valid_session
        }.to raise_error()
      end

      it "given invalid params doesn't create todo_item & renders template new" do
        invalid_todo_item_params = valid_todo_item_params.dup
        invalid_todo_item_params.delete(:content)
        expect {
          post :create, { todo_list_id: subject.todo_list_id, todo_item: invalid_todo_item_params }, valid_session
        }.to change { TodoItem.count }.by(0)
      end

      it "given extra param creates todo_item and redirects to todo_items" do
        invalid_todo_item_params = valid_todo_item_params.dup
        invalid_todo_item_params[:completed_at] = Time.now
        expect {
          post :create, { todo_list_id: subject.todo_list_id, todo_item: invalid_todo_item_params }, valid_session
        }.to change { TodoItem.count }.by(1)
        todo_item = TodoItem.where(content: invalid_todo_item_params[:content]).first
        expect(todo_item.completed_at).to eq(nil)
        expect(response).to redirect_to(todo_list_path(subject.todo_list_id))
      end
    end
  end

  context "PUT update: " do
    context "if user not signed in: " do
      it "redirects to new user session path" do
        put :update, { todo_list_id: subject.todo_list_id, id: subject.id, todo_item: valid_todo_item_params }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "given valid params it updates todo item & redirects to todo items" do
        put :update, { todo_list_id: subject.todo_list_id, id: subject.id, todo_item: valid_todo_item_params }, valid_session
        expect(response).to redirect_to(todo_list_path(subject.todo_list_id))
      end

      it "raises an error on attempt to update todo item that doesn't belong to the user" do
        expect {
          put :update, { todo_list_id: other_todo_list.id, id: subject.id, todo_item: valid_todo_item_params }, valid_session
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises an error on attempt to update todo item from todo list that doesn't belong to the user" do
        expect {
          put :update, { todo_list_id: other_todo_list.id, id: other_todo_item.id, todo_item: valid_todo_item_params}, valid_session
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "given extra param it creates todo_list and redirects to created todo_list" do
        invalid_todo_item_params = valid_todo_item_params.dup
        invalid_todo_item_params[:completed_at] = Time.now
        put :update, { todo_list_id: subject.todo_list_id, id: subject.id, todo_item: invalid_todo_item_params }, valid_session
        subject.reload
        expect(subject.completed_at).to be(nil)
        expect(response).to redirect_to(todo_list_path(subject.todo_list_id))
      end

      context "todo item from invited-todo-list:" do
        it "updates item if invitation confirmed" do
          invitation.update_attribute(:invitation_token, nil)
          put :update, { todo_list_id: invited_todo_item.todo_list_id, id: invited_todo_item.id, todo_item: valid_todo_item_params }, valid_session
          expect(response).to redirect_to(todo_list_path(invited_todo_item.todo_list_id))
        end

        it "doesn't allow to update item if invitation not confirmed" do
          invitation
          expect {
            put :update, { todo_list_id: invited_todo_item.todo_list_id, id: invited_todo_item.id, todo_item: valid_todo_item_params}, valid_session
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  context "PATCH complete: " do
    context "if user not signed in" do
      it "redirects to new user session path" do
        patch :complete, { id: subject.id }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "raises an error on attempt to mark complete todo item that doesn't belong to the user" do
        expect {
          patch :complete, { todo_list_id: other_todo_item.todo_list_id, id: other_todo_item.id, completed: 'true' }, valid_session
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "marks todo item complete" do
        expect(subject.completed_at).to be(nil)
        patch :complete, { todo_list_id: todo_list.id, id: subject.id, completed: 'true' }, valid_session
        expect(response.status).to eq(200)
        subject.reload
        expect(subject.completed_at).to_not be(nil)
      end

      context "todo item from invited-todo-list:" do
        it "raises an error on attempt to mark complete todo item if invitation not confirmed" do
          invitation
          expect {
            patch :complete, { todo_list_id: invited_todo_item.todo_list_id, id: invited_todo_item.id, completed: 'true' }, valid_session
          }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "marks todo item complete if invitation confirmed" do
          invitation.update_attribute(:invitation_token, nil)
          expect(invited_todo_item.completed_at).to be(nil)
          patch :complete, { todo_list_id: invited_todo_item.todo_list_id, id: invited_todo_item.id, completed: 'true' }, valid_session
          expect(response.status).to eq(200)
          invited_todo_item.reload
          expect(invited_todo_item.completed_at).to_not be(nil)
        end
      end
    end
  end

  context "DELETE destroy: " do
    context "if user not signed in: " do
      it "redirects to new user session path" do
        delete :destroy, { todo_list_id: subject.todo_list_id, id: subject.id }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      it "raises an error on attempt to edit todo item from todo list that doesn't belong to the user" do
        expect {
          delete :destroy, { todo_list_id: other_todo_list.id, id: subject.id  }, valid_session
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "doesn't destroy todo item & raises an error on attempt to destroy todo item that doesn't belong to the user" do
        other_todo_item
        expect {
          expect {
            delete :destroy, { todo_list_id: other_todo_list.id, id: other_todo_item.id }, valid_session
          }.to raise_error()
        }.to change { TodoItem.count }.by(0)
      end

      it "destroys todo item & redirects to todo list" do
        expect {
          delete :destroy, { todo_list_id: subject.todo_list_id, id: subject.id }, valid_session
        }.to change { TodoItem.count }.by(-1)
        expect(response).to redirect_to(todo_list_path(subject.todo_list_id))
      end

      context "todo item from invited-todo-list:" do
        it "updates item if invitation confirmed" do
          invitation.update_attribute(:invitation_token, nil)
          expect {
            delete :destroy, { todo_list_id: invited_todo_item.todo_list_id, id: invited_todo_item.id }, valid_session
          }.to change { TodoItem.count }.by(-1)
          expect(response).to redirect_to(todo_list_path(invited_todo_item.todo_list_id))
        end

        it "doesn't allow to update item if invitation not confirmed" do
          invitation
          expect {
            expect {
              delete :destroy, { todo_list_id: invited_todo_item.todo_list_id, id: invited_todo_item.id }, valid_session
            }.to raise_error()
          }.to change { TodoItem.count }.by(0)
        end
      end
    end
  end
end
