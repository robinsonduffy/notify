class CreateDeliveryOptionMessageTypeJoinTable < ActiveRecord::Migration
  def self.up
    create_table :delivery_options_message_types, :id => false do |t|
      t.references :delivery_option
      t.references :message_type
    end
    add_index :delivery_options_message_types, [:delivery_option_id, :message_type_id], :name => 'delivery_options_message_type_join_index_a'
    add_index :delivery_options_message_types, [:message_type_id, :delivery_option_id], :name => 'delivery_options_message_type_join_index_b'
  end

  def self.down
    drop_table :delivery_options_message_types
  end
end
