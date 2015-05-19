class User < ActiveRecord::Base

  has_many :todo_lists
  has_many :invitations
  has_many :invited_todo_lists, class_name: "TodoList", through: :invitations, source: :todo_list

  has_secure_password

  validates :password, length: {minimum: 6, allow_nil: true}
  validates :email, presence: true,
    uniqueness: true,
    format: { with: /\A[a-z0-9._+-]+@[a-z0-9.-]+\.[a-z]+\z/ }

  before_validation :downcase_email
  before_create :generate_activation_token

  def downcase_email
    self.email = email.downcase if self.email
  end

  def activate!
    self.update_attribute('activation_token', nil)
  end

  private
  def generate_activation_token
    self.activation_token ||= SecureRandom.hex(8)
  end

end
