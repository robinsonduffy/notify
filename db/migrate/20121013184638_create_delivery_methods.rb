class CreateDeliveryMethods < ActiveRecord::Migration
  def self.up
    create_table :delivery_methods do |t|
      t.references :message
      t.references :contact_method_type
      t.references :from_method

      t.timestamps
    end
    add_index :delivery_methods, :message_id
  end

  def self.down
    drop_table :delivery_methods
  end
end
