require 'spec_helper'

describe UserActivationService do

  let(:user) { FactoryGirl.create(:unconfirmed_user) }

  it "updates activation_token to nil" do
    expect(user.activation_token).to_not eq(nil)
    UserActivationService.new(user: user).activate!
    expect(user.activation_token).to eq(nil)
  end

end
