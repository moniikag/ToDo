require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }

  it "validates" do
    expect(subject).to be_valid
  end

  it 'validates new User with basic parameters' do
    user = User.new(email: 'example@example.com', password: 'password', password_confirmation: 'password')
    expect(user).to be_valid
  end

  context '#has_secure_password' do
    it "validates user when correct password is given" do
      subject.password = 'password'
      subject.password_confirmation = 'password'
      expect(subject).to be_valid
    end

    it "doesn't validate user with no password" do
      subject.password = ''
      subject.password_confirmation = ''
      expect(subject).to_not be_valid
    end
  end

  context '#validates password length' do
    it "doesn't validate user when password is too short (min. 6 characters)" do
      subject.password = 'passw'
      subject.password_confirmation = 'passw'
      expect(subject).to_not be_valid
    end
  end

  context "#validates email format" do
    it 'validates user when valid email is given' do
      subject.email = 'example@example.com'
      expect(subject).to be_valid
    end

    it "doesn't validate when no email is given" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "doesn't validate user when empty email is given" do
      subject.email = ''
      expect(subject).to_not be_valid
    end

    it "doesn't validate user when invalid email is given: 'email'" do
      subject.email = 'email'
      expect(subject).to_not be_valid
    end

    it "doesn't validate user when invalid email is given: 'email@email'" do
      subject.email = 'email@email'
      expect(subject).to_not be_valid
    end

    it "doesn't validate user when invalid email is given: '@email.com'" do
      subject.email = '@email.com'
      expect(subject).to_not be_valid
    end

    it 'validates downcased email when downcase email given' do
      subject.email = 'downcase@email.com'
      subject.valid?
      expect(subject.email).to eq('downcase@email.com')
    end

    it 'validates downcased email when upcase email given' do
      subject.email = 'UPCASE@EMAIL.COM'
      subject.valid?
      expect(subject.email).to eq('upcase@email.com')
    end

    it 'validates downcased email when camelcase email given' do
      subject.email = 'CamelCase@Email.CoM'
      subject.valid?
      expect(subject.email).to eq('camelcase@email.com')
    end
  end

end
