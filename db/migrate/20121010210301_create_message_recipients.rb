class CreateMessageRecipients < ActiveRecord::Migration
  def self.up
    create_table :message_recipients do |t|
      t.integer :message_id
      t.integer :object_id
      t.string :object_type

      t.timestamps
    end
    add_index :message_recipients, [:message_id, :object_id, :object_type], :unique => true, :name => 'index_message_recipients_on_object_combo'
  end

  def self.down
    drop_table :message_recipients
  end
end
