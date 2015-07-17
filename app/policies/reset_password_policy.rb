class ResetPasswordPolicy < Struct.new(:user, :reset_password)

  def new?
    !@user
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  def update?
    new?
  end

end
