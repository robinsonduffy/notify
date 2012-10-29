class AddSendableToRecipientType < ActiveRecord::Migration
  def self.up
    add_column :recipient_types, :sendable, :boolean
  end

  def self.down
    remove_column :recipient_types, :sendable
  end
end
