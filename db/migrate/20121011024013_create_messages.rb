class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :name
      t.references :user

      t.timestamps
    end
    add_index :messages, :user_id
  end

  def self.down
    drop_table :messages
  end
end
