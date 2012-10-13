class CreateScripts < ActiveRecord::Migration
  def self.up
    create_table :scripts do |t|
      t.string :script_type
      t.text :script
      t.integer :script_order, :default => 0
      t.references :delivery_method

      t.timestamps
    end
    add_index :scripts, :delivery_method_id
  end

  def self.down
    drop_table :scripts
  end
end
