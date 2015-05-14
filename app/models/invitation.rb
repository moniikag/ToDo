class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :todo_list

  private

  def generate_invitation_token
    if self.invitation_token.blank?
      self.invitation_token = "#{SecureRandom.hex(8)}"
    end
  end
end
