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

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  private
  def downcase_email
    self.email = email.downcase if self.email
  end

  def generate_activation_token
    self.activation_token ||= SecureRandom.hex(8)
  end

end
