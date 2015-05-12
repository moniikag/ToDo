class AddConfirmationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_token, :string
  end
end