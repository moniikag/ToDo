require 'spec_helper'

describe ActivateUser do

  let(:user) { FactoryGirl.create(:unconfirmed_user) }

  it "updates activation_token to nil" do
    expect(user.activation_token).to_not eq(nil)
    ActivateUser.call(user: user)
    expect(user.activation_token).to eq(nil)
  end

  it "it doesn't change activation token if nil" do
    user.update_attribute('activation_token', nil)
    ActivateUser.call(user: user)
    expect(user.activation_token).to eq(nil)
  end

end
