class ActivateUser

  def self.call(user:)
    user.update_attribute('activation_token', nil)
  end

end
