class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :todo_list_id
      t.integer :user_id
      t.string :invitation_token
      t.string :invited_user_email
    end

    add_index :invitations, :todo_list_id
    add_index :invitations, :user_id
  end
end
