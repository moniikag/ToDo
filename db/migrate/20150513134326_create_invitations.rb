class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :todo_list_id
      t.integer :user_id
      t.string :invitation_token
    end

    add_index :invitations, :todo_list_id
    add_index :invitations, :user_id
  end
end
