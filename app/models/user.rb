class User < ActiveRecord::Base

	has_many :todo_lists

	has_secure_password
	validates :password, length: {minimum: 6, allow_nil: true}
	validates :email, presence: true,
										uniqueness: true,
										format: { with: /\A[a-z0-9._+-]+@[a-z0-9.-]+\.[a-z]+\z/ }

	before_validation :downcase_email

	def downcase_email 
		self.email = email.downcase if self.email
	end
end