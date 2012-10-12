class RemoveOptionsMaskFromDeliveryOption < ActiveRecord::Migration
  def self.up
    remove_column :delivery_options, :options_mask
  end

  def self.down
    add_column :delivery_options, :options_mask, :integer
  end
end
