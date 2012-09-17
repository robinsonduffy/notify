class CreateLinkedRecipients < ActiveRecord::Migration
  def self.up
    create_table :linked_recipients do |t|
      t.integer :student_id
      t.integer :parent_id

      t.timestamps
    end
    add_index :linked_recipients, :student_id
    add_index :linked_recipients, :parent_id
    add_index :linked_recipients, [:parent_id, :student_id], :unique => true
  end

  def self.down
    drop_table :linked_recipients
  end
end
