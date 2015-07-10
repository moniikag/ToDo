class PasswordResetter

  def initialize(user:, password: nil, password_confirmation: nil)
    @user = user
    @password = password
    @password_confirmation = password_confirmation
  end

  def generate_token
    @user.update_attributes(password_token: SecureRandom.hex(8), password_token_generated: Time.now)
  end

  # def reset_password
  #   @user.update_attributes(
  #     password: @password,
  #     password_confirmation: @password_confirmation,
  #     password_token: nil,
  #     password_token_generated: nil)
  # end
end
