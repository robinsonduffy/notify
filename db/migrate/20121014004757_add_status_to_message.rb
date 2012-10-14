class AddStatusToMessage < ActiveRecord::Migration
  def self.up
    add_column :messages, :status, :integer, :default => 1
    add_index :messages, :status
  end

  def self.down
    remove_index :messages, :status
    remove_column :messages, :status
  end
end
