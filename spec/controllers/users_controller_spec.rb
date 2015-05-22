require 'spec_helper'

RSpec.describe UsersController do

  let(:subject) { FactoryGirl.create(:user) }
  let(:valid_session) { { user_id: subject.id } }
  let(:valid_user_param) { {
    first_name: "name", last_name: "last", email: "newtest@example.com",
    password:'password', password_confirmation: 'password'
  } }

  context "GET new: " do
    let(:invitation_for_not_registered) { FactoryGirl.create(:invitation, invited_user_email: 'some@email.com') }

    context "if user not signed in: " do
      it "renders action new" do
        get :new
        expect(response.status).to be(200)
        expect(response).to render_template(:new)
        expect(assigns(:user)).to be_a_new(User)
      end

      context "following invitation+registration link " do
        it "renders action new if user not registered yet" do
          get :new, { email: invitation_for_not_registered.invited_user_email, invitation_token: invitation_for_not_registered.invitation_token }
          expect(response.status).to be(200)
          expect(response).to render_template(:new)
          expect(assigns(:user)).to be_a_new(User)
        end

        it 'redirects to Invitation#confirm if user registered in the meantime' do
          invitation_for_not_registered.update_attribute('invited_user_email', subject.email)
          get :new, { email: invitation_for_not_registered.invited_user_email,
            invitation_token: invitation_for_not_registered.invitation_token, list: '1' }
          expect(response).to redirect_to(confirm_todo_list_invitations_path(email: invitation_for_not_registered.invited_user_email,
            token: invitation_for_not_registered.invitation_token, todo_list_id: '1'))
        end
      end
    end

    context "if user signed in: " do
      it "redirects to root path" do
        expect {
          get :new, {}, valid_session
        }.to raise_error(Pundit::NotAuthorizedError)
      end

      context "following invitation+registration link " do
        it 'redirects to Invitation#confirm if user registered in the meantime' do
          invitation_for_not_registered.update_attribute('invited_user_email', subject.email)
          get :new, { email: invitation_for_not_registered.invited_user_email,
            invitation_token: invitation_for_not_registered.invitation_token, list: '1' }, valid_session
          expect(response).to redirect_to(confirm_todo_list_invitations_path(email: invitation_for_not_registered.invited_user_email,
            token: invitation_for_not_registered.invitation_token, todo_list_id: '1'))
        end
      end
    end
  end

  context "POST create: " do
    context "if user signed in: " do
      it "redirects to root path" do
        expect {
          post :create, { user: valid_user_param } , valid_session
        }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "if user not signed in: " do
      it "given valid params creates user and redirects to root_path " do
        expect {
          post :create, user: valid_user_param
        }.to change { User.count }.by(1)
        expect(response).to redirect_to(root_path)
      end

      it "sends confirmation email when creating user" do
        expect {
          post :create, user: valid_user_param
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "given extra params creates user and redirects to root_path " do
        expect {
          post :create, user: valid_user_param.merge(extra: 'homo sapiens')
        }.to change { User.count }.by(1)
        expect(response).to redirect_to(root_path)
      end

      it "given invalid params renders template :new" do
        params = valid_user_param.dup
        params.delete(:email)
        expect {
          post :create, user: params
        }.to change { User.count }.by(0)
        expect(response.status).to be(200)
        expect(response).to render_template(:new)
        expect(assigns(:user)).to be_a_new(User)
      end

      context "registration after following invitation-to-todo_list-link" do
        let(:invitation_for_not_registered) { FactoryGirl.create(:invitation, invited_user_email: valid_user_param[:email]) }

        it "creates user and redirects to Invitation#confirm if valid link provided" do
          invitation_for_not_registered
          expect {
            post :create, { user: valid_user_param, invitation_token: invitation_for_not_registered.invitation_token,
              todo_list_id: invitation_for_not_registered.todo_list_id }
          }.to change{ User.count }.by(1)
          expect(response).to redirect_to(confirm_todo_list_invitations_path(email: valid_user_param[:email],
            token: invitation_for_not_registered.invitation_token, todo_list_id: invitation_for_not_registered.todo_list_id))
        end

        it "creates user and redirects to root_path if invalid token provided" do
          invitation_for_not_registered
          expect {
            post :create, { user: valid_user_param, invitation_token: '12345',
              todo_list_id: invitation_for_not_registered.todo_list_id }
          }.to change{ User.count }.by(1)
          expect(response).to redirect_to(root_path)
        end

        it "creates user and redirects to root_path if blank token provided" do
          invitation_for_not_registered
          expect {
            post :create, { user: valid_user_param, invitation_token: '', todo_list_id: invitation_for_not_registered.todo_list_id }
          }.to change{ User.count }.by(1)
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  context "GET confirm_email" do
    let(:unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }
    let(:another_unconfirmed_user) { FactoryGirl.create(:unconfirmed_user) }
    let(:another_activation_token) { SecureRandom.hex(8) }

    context "if user not signed in: " do
      context "if user not activated: " do
        it "gets valid activation link -> assigns user, redirects to root_path, flash[:success]" do
          get :confirm_email, { email: unconfirmed_user.email, activation_token: unconfirmed_user.activation_token }
          expect(assigns(:user)).to eq(unconfirmed_user)
          expect(response).to redirect_to(root_path)
          expect(flash[:success]).to be_present
        end

        it 'gets valid activation link and activates user' do
          expect(unconfirmed_user.activation_token).to_not be_nil
          get :confirm_email, { email: unconfirmed_user.email, activation_token: unconfirmed_user.activation_token }
          unconfirmed_user.reload
          expect(unconfirmed_user.activation_token).to be_nil
        end

        it "gets another user's token and redirects to new_user_session_path + flash[:error]" do
          get :confirm_email, { email: unconfirmed_user.email, activation_token: another_unconfirmed_user.activation_token }
          expect(assigns(:user)).to eq(nil)
          expect(response).to redirect_to(new_user_sessions_path)
          expect(flash[:error]).to be_present
        end

        it "gets invalid token and redirects to new_user_session_path + flash[:error]" do
          get :confirm_email, { email: unconfirmed_user.email, activation_token: "12345" }
          expect(assigns(:user)).to eq(nil)
          expect(response).to redirect_to(new_user_sessions_path)
          expect(flash[:error]).to be_present
        end

        it "gets no token and redirects to new_user_session_path + flash[:error]" do
          get :confirm_email, { email: unconfirmed_user.email }
          expect(assigns(:user)).to eq(nil)
          expect(response).to redirect_to(new_user_sessions_path)
          expect(flash[:error]).to be_present
        end

        it "gets unknown email and redirects to new_user_session_path + flash[:error]" do
          get :confirm_email, { email: "email@noemail.com", activation_token: unconfirmed_user.activation_token }
          expect(assigns(:user)).to eq(nil)
          expect(response).to redirect_to(new_user_sessions_path)
          expect(flash[:error]).to be_present
        end
      end

      context "if user activated: " do
        it "gets the same token again and redirects to new_user_session_path + flash[:error]" do
          token = unconfirmed_user.activation_token
          unconfirmed_user.update_attribute('activation_token', nil)
          get :confirm_email, { email: unconfirmed_user.email, activation_token: token }
          expect(assigns(:user)).to eq(nil)
          expect(response).to redirect_to(new_user_sessions_path)
          expect(flash[:error]).to be_present
        end

        it "gets invalid token and redirects to new user_session_path + flash[:error]" do
          get :confirm_email, { email: subject.email, activation_token: '12345' }
          expect(assigns(:user)).to eq(nil)
          expect(response).to redirect_to(new_user_sessions_path)
          expect(flash[:error]).to be_present
        end

        it "gets no token -> assigns user & Pundit rescure redirects to new_user_sessions_path + flash[:error]" do
          get :confirm_email, { email: subject.email }
          expect(assigns(:user)).to eq(subject)
          expect(response).to redirect_to(new_user_sessions_path)
          expect(flash[:error]).to be_present
        end
      end
    end

    context "if user signed in" do
      it "if user signed in rescue from Pundit redirects to new_user_sessions_path + flash[:error]" do
        get :confirm_email, { email: subject.email, token: another_activation_token }, valid_session
        expect(response).to redirect_to(new_user_sessions_path)
        expect(flash[:error]).to be_present
      end
    end
  end

  context "GET edit: " do
    context "if user not signed in: " do
      it "renders action edit" do
        get :edit, { id: subject.id }
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in: " do
      let(:other_user) { users(:tom) }

      it "redirects to edit" do
        get :edit, { id: subject.id }, valid_session
        expect(response.status).to be(200)
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(subject)
      end

      it "doesn't allow to edit user on attempt to edit another user & redirects to root_path" do
        expect {
          get :edit, { id: other_user.id }, valid_session
        }.to raise_error()
      end
    end
  end

  context "PUT update" do
    context "if user not signed in" do
      it "redirects to new_user_sessions_path" do
        put :update, id: subject.id
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      it "given correct params updates user and redirects to user" do
        put :update, { id: subject.id, user: { first_name: "name" } }, valid_session
        expect(response).to redirect_to(root_path)
      end

      it "given invalid params renders tempate edit" do
        put :update, { id: subject.id, user: { email: "" } }, valid_session
        expect(response).to render_template(:edit)
      end
    end
  end

  context "DELETE destroy" do
    context "if user not signed in" do
      it "doesn't destroy user & redirects to new_user_sessions_path" do
        subject
        expect {
          delete :destroy, { id: subject.id }
        }.to change { User.count }.by(0)
        expect(response).to redirect_to(new_user_sessions_path)
      end
    end

    context "if user signed in" do
      let(:other_user) { users(:tom) }

      it "destroys the user on attempt to destroy himself & recirects to users" do
        delete :destroy, { id: subject.id }, valid_session
        expect(response).to redirect_to(new_user_sessions_path)
      end

      it "doesn't destroy user on attempt to destroy another user & redirects to root_path" do
        expect {
          delete :destroy, { id: other_user.id }, valid_session
        }.to raise_error()
      end
    end
  end

end
