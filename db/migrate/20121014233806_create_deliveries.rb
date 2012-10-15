class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.text :delivered_message
      t.integer :delivery_result
      t.references :delivery_method
      t.references :contact_method

      t.timestamps
    end
    add_index :deliveries, :contact_method_id
    add_index :deliveries, :delivery_method_id
  end

  def self.down
    drop_table :deliveries
  end
end
