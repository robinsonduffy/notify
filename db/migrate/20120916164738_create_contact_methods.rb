class CreateContactMethods < ActiveRecord::Migration
  def self.up
    create_table :contact_methods do |t|
      t.string :contact_method_type
      t.string :delivery_route
      t.references :recipient

      t.timestamps
    end
    add_index :contact_methods, :recipient_id
  end

  def self.down
    drop_table :contact_methods
  end
end
