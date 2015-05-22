class UserActivationService

  def self.call(user:)
    user.update_attribute('activation_token', nil) unless user.activation_token.nil?
  end

end
