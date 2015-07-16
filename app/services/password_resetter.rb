class PasswordResetter

  def initialize(user:)
    @user = user
  end

  def generate_token
    @user.update_attributes(password_token: SecureRandom.hex(8), password_token_generated: Time.now)
  end

end
