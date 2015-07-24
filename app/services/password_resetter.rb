class PasswordResetter
  require 'base64'

  def initialize(user: nil, token: nil)
    @user = user
    @token = token
  end

  def generate_token
    reset_token = loop do
      token = Base64.encode64("#{SecureRandom.hex(12)}#{Time.now}")
      break token unless User.where(password_token: token).exists?
    end
    @user.update_attribute(:password_token, reset_token)
  end

  def decode_time
    time = Base64.decode64(@token).slice(-25,25)
    token_datetime = Time.parse(time)
  end

end
