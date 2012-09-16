class CreateRecipients < ActiveRecord::Migration
  def self.up
    create_table :recipients do |t|
      t.string :external_id
      t.string :recipient_type
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
    add_index :recipients, [:external_id, :recipient_type], :unique => true
    add_index :recipients, :recipient_type
  end

  def self.down
    drop_table :recipients
  end
end
