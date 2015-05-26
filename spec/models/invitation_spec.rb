require 'spec_helper'

describe Invitation do
  let(:invitation) { FactoryGirl.create(:invitation_with_email) }

  it "validates" do
    expect(invitation).to be_valid
  end

  context "#validates_email" do
    it "validates invitation when valid email given" do
      invitation.invited_user_email = 'example@example.com'
      expect(invitation).to be_valid
    end

    it "doesn't validate invitation when no email is given" do
      invitation.invited_user_email = nil
      print invitation.invited_user_email
      expect(invitation).to_not be_valid
    end

    it "doesn't validate invitation when empty email is given" do
      invitation.invited_user_email = ''
      expect(invitation).to_not be_valid
    end

    it "doesn't validate invitation when invalid email is given: 'email'" do
      invitation.invited_user_email = 'email'
      expect(invitation).to_not be_valid
    end

    it "doesn't validate invitation when invalid email is given: 'email@email'" do
      invitation.invited_user_email = 'email@email'
      expect(invitation).to_not be_valid
    end

    it "doesn't validate invitation when invalid email is given: '@email.email'" do
      invitation.invited_user_email = '@email.email'
      expect(invitation).to_not be_valid
    end

    it "validates donwcase email when downcase email is given" do
      invitation.invited_user_email = 'downcase@email.com'
      invitation.valid?
      expect(invitation.invited_user_email).to eq('downcase@email.com')
    end

    it "validates downcase email when upcase email is given" do
      invitation.invited_user_email = 'UPCASE@EMAIL.COM'
      invitation.valid?
      expect(invitation.invited_user_email).to eq('upcase@email.com')
    end

    it "validates downcase email when camelcase email is given" do
      invitation.invited_user_email = 'CamelCase@Email.Com'
      invitation.valid?
      expect(invitation.invited_user_email).to eq('camelcase@email.com')
    end
  end

  context "#generate_invitation_token" do
    it "creates invitation and automaticaly generates invitation_token" do
      expect(invitation.invitation_token).to be_true
    end
  end

  context "#set_invited_user" do
    it "sets user_id when creating invitation if existing_user was invited" do
      expect(invitation.user_id).to be_true
    end
  end

  context "#activate!" do
    it "sets invitation_token to nil" do
      expect(invitation.invitation_token).to_not be_nil
      invitation.activate!
      expect(invitation.invitation_token).to be_nil
    end

    it "sets invitation_token to nil and set's user_id if not_registered_user was invited" do
      invitation_new = FactoryGirl.create(:invitation, invited_user_email: "not@existing.user")
      user = FactoryGirl.create(:user)
      user.update_attribute('email', "not@existing.user")

      expect(invitation_new.invitation_token).to_not be_nil
      expect(invitation_new.user_id).to be_nil
      invitation_new.activate!
      expect(invitation_new.invitation_token).to be_nil
      expect(invitation_new.user_id).to eq(user.id)
    end
  end

end
