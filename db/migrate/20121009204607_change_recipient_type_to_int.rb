class ChangeRecipientTypeToInt < ActiveRecord::Migration
  def self.up
    remove_index :recipients, :recipient_type
    remove_index :recipients, [:external_id, :recipient_type]
    remove_column :recipients, :recipient_type
    add_column :recipients, :recipient_type_id, :integer
    add_index :recipients, :recipient_type_id
    add_index :recipients, [:external_id, :recipient_type_id], :unique => true
  end

  def self.down
    remove_index :recipients, :recipient_type_id
    remove_index :recipients, [:external_id, :recipient_type_id]
    remove_column :recipients, :recipient_type_id
    add_column :recipients, :recipient_type, :string
    add_index :recipients, :recipient_type
    add_index :recipients, [:external_id, :recipient_type], :unique => true
  end
end
