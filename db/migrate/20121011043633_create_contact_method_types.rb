class CreateContactMethodTypes < ActiveRecord::Migration
  def self.up
    create_table :contact_method_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_method_types
  end
end
