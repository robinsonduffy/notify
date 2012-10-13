class CreateFromMethods < ActiveRecord::Migration
  def self.up
    create_table :from_methods do |t|
      t.string :from_method_type
      t.string :from_method
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :from_methods
  end
end
