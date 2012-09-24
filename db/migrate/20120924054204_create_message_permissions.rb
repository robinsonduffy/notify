class CreateMessagePermissions < ActiveRecord::Migration
  def self.up
    create_table :message_permissions do |t|
      t.integer :object_id
      t.string :object_type
      t.integer :user_id

      t.timestamps
    end
    add_index :message_permissions, [:user_id, :object_id, :object_type], :unique => true, :name => 'index_message_permissions_on_object_combo'
  end

  def self.down
    drop_table :message_permissions
  end
end
