require 'spec_helper'

describe UserSessionController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "renders the new template" do
      get 'new'
      expect(response).to render_template('new')     
    end
  end

  describe "POST 'create'" do
    context "with correct credentials" do   
      let!(:user) { User.create(first_name: "tom", last_name: "tom", email: "tom@tom.tom", password: "12345", password_confirmation: "12345")}
      #if we use ! with let, these credentials will be created before any of next scenarios run
      # without ! ruby waits till we call :user
    
    it "redirects to the todo list path" do
       post :create, email: "tom@tom.tom", password: "12345"
        expect(response).to be_redirect
        expect(response).to redirect_to(todo_lists_path)
    end

    it "finds the user" do
      expect(User).to receive(:find_by).with({email: "tom@tom.tom"}).and_return(user)
      post :create, email: "tom@tom.tom", password: "12345"
    end

    it "authenticates the user" do
      User.stub(:find_by).and_return(user)
      expect(user).to receive(:authenticate)
      post :create, email: "tom@tom.tom", password: "12345"
    end

    it "sets the user_id in the session" do
      post :create, email: "tom@tom.tom", password:"12345"
      expect(session[:user_id]).to eq(user.id)
    end

    it "sets the flash succes message" do
      post :create, email: "tom@tom.tom", password: "12345"
      expect(flash[:success]).to eq("Thanks for logging in!")
    end
end

shared_examples_for "denied login" do
   it "renders the new template" do
    post :create, email: email, password: password
    expect(response).to render_template('new')    
  end
   it "sets the flash error message" do
    post :create
    expect(flash[:error]).to eq("There was a problem loggin in. Please check your email and password")    
  end
end


context "with blank credentials" do
  let(:email) { "" }
  let(:password) { "" }
  it_behaves_like "denied login"
end

context "with an incorrect password" do
  let!(:user) { User.create(first_name: "tom", last_name: "tom", email: "tom@tom.tom", password: "12345", password_confirmation: "12345")}
  let(:email) { user.email }
  let(:password) { "incorrect" }
  it_behaves_like "denied login"
end



  it "sets the session user id to the created user" do
    post :create, {:user => valid_attributes}, valid_session
    expect(session[:user_id]).to eq(User.find_by(email: valid_attributes["email"]).id)
  end

context "with no email in existence" do
  let(:email) {"none@found.com"}
  let(:password) { "incorrect" }
  it_behaves_like "denied login"  
end

end
end


