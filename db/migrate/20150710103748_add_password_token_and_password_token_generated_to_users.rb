class AddPasswordTokenAndPasswordTokenGeneratedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_token, :string
    add_column :users, :password_token_generated_at, :datetime
  end
end
