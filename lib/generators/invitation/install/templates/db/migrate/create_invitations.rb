class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.string :token
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :organizable_id
      t.string  :organizable_type
      t.timestamps
      t.index :email
      t.index :token
      t.index [:organizable_id, :organizable_type]
      t.index :recipient_id
      t.index :sender_id
    end
  end
end
