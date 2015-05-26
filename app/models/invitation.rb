class Invitation < ActiveRecord::Base

  before_create :generate_invitation_token, :set_invited_user

  belongs_to :user
  belongs_to :todo_list

  validates :invited_user_email, presence: true,
    format: { with: /\A[a-z0-9._+-]+@[a-z0-9.-]+\.[a-z]+\z/ },
    uniqueness: { scope: :todo_list_id, message: "This User have already been invited to the TodoList" }
  validate :not_inviting_self, on: :create

  before_validation :downcase_email

  def activate!
    self.update_attribute('invitation_token', nil)
    self.update_attribute('user_id', User.find_by_email(self.invited_user_email).id) if self.user_id.nil?
  end

  def new_user?
    User.where(email: self.invited_user_email).empty?
  end

  private
  def downcase_email
    self.invited_user_email = invited_user_email.downcase if self.invited_user_email
  end

  def generate_invitation_token
    self.invitation_token ||= SecureRandom.hex(8)
  end

  def set_invited_user
    self.user = User.find_by_email(self.invited_user_email)
  end

  def not_inviting_self
    errors.add(:invited_user_email, "You can't invite yourself") if self.todo_list.user.email == self.invited_user_email
  end

end
