require 'spec_helper'

Rspec.describe ResetPasswordsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_session) { { user_id: user.id } }

  context "GET new" do
    it "redirects to root path if user logged_in" do
      get :new, {}, valid_session
      expect(response.status).to be(302)
      expect(response).to redirect_to(root_path)
    end

    it "renders action new if no current_user" do
      get :new
      expect(response.status).to be(200)
      expect(response).to render_template(:new)
    end
  end

  context "POST create" do
    context "user logged in" do
      it "redirects to root path if user logged_in" do
        post :create, { email: user.email }, valid_session
        expect(response.status).to be(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context "user not logged in" do
      it "if existing user's email given: assigns user and redirects to root_path" do
        post :create, { email: user.email }
        expect(assigns(:user)).to eq(user)
        expect(response.status).to be(302)
        expect(response).to redirect_to(root_path)
      end

      it "if unknown email given: renders new" do
        post :create, { email: 'email' }
        expect(response.status).to be(200)
        expect(response).to render_template(:new)
      end
    end
  end

  context "GET edit" do
    before(:each) do
      PasswordResetter.new(user: user).generate_token
    end

    context "user logged in" do
      it "redirects to root path if user logged_in" do
        get :edit, { token: user.password_token }, valid_session
        expect(response.status).to be(302)
        expect(response).to redirect_to(root_path)
      end
    end

    context "user not logged in" do
      it "renders action edit and assigns user if correct token given" do
        get :edit, { token: user.password_token }
        expect(response.status).to be(200)
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(user)
      end

      it "renders action edit but doesn't assign user if wrong token given" do
        get :edit, { token: 'token' }
        expect(response.status).to be(200)
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(nil)
      end

      it "renders action edit but doesn't assign user if too old token given" do
        user.update_attribute('password_token_generated_at', 24.hours.ago)
        get :edit, { token: user.password_token }
        expect(response.status).to be(200)
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(nil)
      end
    end
  end

  context 'PATCH update' do
    before(:each) do
      PasswordResetter.new(user: user).generate_token
    end

    context "user logged in " do
      it "redirects to root path if user logged_in, doesn't assing user" do
        patch :update, { email: user.email, password: 'secret', password_confirmation: 'secret', token: user.password_token }, valid_session
        expect(response.status).to be(302)
        expect(response).to redirect_to(root_path)
        expect(assigns(:user)).to eq(nil)
      end
    end

    context "user not logged in" do
      it "updates password and redirects to root path" do
        patch :update, { email: user.email, password: 'secret', password_confirmation: 'secret', token: user.password_token }
        expect(response.status).to be(302)
        expect(response).to redirect_to(root_path)
        expect(assigns(:user)).to eq(user)
      end

      it "renders edit for invalid password" do
        patch :update, { email: user.email, password: 's', password_confirmation: 'secret', token: user.password_token }
        expect(response.status).to be(200)
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(user)
      end

      it "renders edit if email doesn't match token" do
        patch :update, { email: 'email', password: 'secret', password_confirmation: 'secret', token: user.password_token }
        expect(response.status).to be(200)
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(user)
      end

      it "renders edit for too old token" do
        user.update_attribute('password_token_generated_at', 24.hours.ago)
        patch :update, { email: user.email, password: 'secret', password_confirmation: 'secret', token: user.password_token }
        expect(response.status).to be(200)
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq(nil)
      end
    end
  end
end

