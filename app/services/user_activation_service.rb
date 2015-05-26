class UserActivationService

  def initialize(user:)
    @user = user
  end

  def activate!
    @user.update_attribute('activation_token', nil) unless @user.activation_token.nil?
  end

end
