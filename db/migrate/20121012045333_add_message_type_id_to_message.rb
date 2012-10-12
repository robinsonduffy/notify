class AddMessageTypeIdToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :message_type_id, :integer
    add_index :messages, :message_type_id
  end

  def self.down
    remove_index :messages, :message_type_id
    remove_column :messages, :message_type_id
  end
end
