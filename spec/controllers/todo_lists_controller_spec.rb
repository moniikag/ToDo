require 'spec_helper'

RSpec.describe TodoListsController do
  fixtures :all
  subject { users(:john) }

  let!(:valid_session) { cookies.permanent[:user_id] = subject.id }

  describe "GET index: " do

    context "user signed in" do
      it "renders action index" do
        get :index, {}, valid_session
        expect(controller.current_user).to eq(true)
        expect(response).to render_template(:index)
      end
    end
  end

end