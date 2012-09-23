class CreateContactMethodListJoinTable < ActiveRecord::Migration
  def self.up
    create_table :contact_methods_lists, :id => false do |t|
      t.references :contact_method
      t.references :list
    end
    add_index :contact_methods_lists, [:contact_method_id, :list_id]
    add_index :contact_methods_lists, [:list_id, :contact_method_id]
  end

  def self.down
    drop_table :contact_methods_lists
  end
end
