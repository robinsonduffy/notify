class ChangeContactTypeToInt < ActiveRecord::Migration
  def self.up
    remove_column :contact_methods, :contact_method_type
    add_column :contact_methods, :contact_method_type_id, :integer
    add_index :contact_methods, :contact_method_type_id
  end

  def self.down
    remove_index :contact_methods, :contact_method_type_id
    remove_column :contact_methods, :contact_method_type_id
    add_column :cotact_methods, :contact_method_type, :string
  end
end
