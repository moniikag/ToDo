require 'spec_helper'

describe ActivateInvitation do

  let(:user) { FactoryGirl.create(:user) }
  let(:invitation) { FactoryGirl.create(:invitation, invited_user_email: user.email) }

  it "updates invitation_token to nil" do
    expect(invitation.invitation_token).to_not eq(nil)
    ActivateInvitation.call(invitation: invitation)
    expect(invitation.invitation_token).to eq(nil)
  end

  it "updates user_id if user_id is nil" do
    invitation.update_attribute('user_id', nil)
    expect(invitation.user_id).to eq(nil)
    ActivateInvitation.call(invitation: invitation)
    expect(invitation.user_id).to eq(user.id)
  end

end
