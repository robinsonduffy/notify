class CreateDeliveryOptions < ActiveRecord::Migration
  def self.up
    create_table :delivery_options do |t|
      t.string :option_scope
      t.integer :scope_id
      t.integer :options_mask
      t.references :contact_method

      t.timestamps
    end
    add_index :delivery_options, :contact_method_id
    add_index :delivery_options, [:contact_method_id,:option_scope, :scope_id], :name => 'index_delivery_options_on_scope_combo'
  end

  def self.down
    drop_table :delivery_options
  end
end
