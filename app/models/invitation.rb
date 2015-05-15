class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :todo_list
  before_create :generate_invitation_token
  before_create :set_invited_user

  validates :invited_user_email, presence: true,
    format: { with: /\A[a-z0-9._+-]+@[a-z0-9.-]+\.[a-z]+\z/ },
    uniqueness: { scope: :todo_list_id, message: "This User have already been invited to the TodoList" }
  before_validation :downcase_email

  private

  def activate!
    self.update_attribute('invitation_token', nil)
  end

  def generate_invitation_token
    self.invitation_token ||= SecureRandom.hex(8)
  end

  def downcase_email
    self.invited_user_email = invited_user_email.downcase if self.invited_user_email
  end

  def set_invited_user
    self.user = User.find_by_email(self.invited_user_email)
  end
end
