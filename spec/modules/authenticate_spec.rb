require 'spec_helper'

describe Authenticate do
  let(:user) { FactoryGirl.create(:user) }

  class ExampleClass < ActionController::Base
    include Authenticate
  end

  before(:each) do
    @object = ExampleClass.new
  end

  context "sign_in" do
    before(:each) do
      @cookies = double(:permanent => { } )
      allow(@object).to receive(:cookies).and_return(@cookies)
    end

    it "sets cookies.permanent to object.id" do
      @object.sign_in(user)
      expect(@cookies.permanent[:user_id]).to eq(user.id)
    end
  end

  context "sign_out " do
    before(:each) do
      @cookies = Hash.new {}
      allow(@object).to receive(:cookies).and_return(@cookies)
    end

    it "sets cookies[:user_id] to nil" do
      @cookies[:user_id] = user.id
      @object.sign_out
      expect(@cookies[:user_id]).to eq(nil)
    end
  end

  context "current_user " do
    before(:each) do
      @cookies = Hash.new {}
      @session = Hash.new {}
      allow(@object).to receive(:cookies).and_return(@cookies)
      allow(@object).to receive(:session).and_return(@session)
      allow(@object).to receive(:redirect_to).and_return(true)
      allow(@object).to receive(:new_user_sessions_path).and_return(true)
    end

    it "sets current_user to given object id" do
      @cookies[:user_id] = user.id
      expect(@object.current_user).to eq(user)
    end

    context "authenticate_user" do
      it "does not redirect to new_user_sessions_path if current_user" do
        @cookies[:user_id] = user.id
        expect(@object.authenticate_user).to be_nil
      end

      it "redirects to new_user_sessions_path if no current_user" do
        expect(@object.authenticate_user).to be_true
      end
    end
  end

end
