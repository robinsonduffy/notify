class CreateMessageTypes < ActiveRecord::Migration
  def self.up
    create_table :message_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :message_types, :name, :unique => true
  end

  def self.down
    drop_table :message_types
  end
end
