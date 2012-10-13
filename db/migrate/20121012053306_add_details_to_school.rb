class AddDetailsToSchool < ActiveRecord::Migration
  def self.up
    add_column :schools, :street1, :string
    add_column :schools, :street2, :string
    add_column :schools, :city, :string
    add_column :schools, :zip, :string
    add_column :schools, :state, :string
  end

  def self.down
    remove_column :schools, :state
    remove_column :schools, :zip
    remove_column :schools, :city
    remove_column :schools, :street2
    remove_column :schools, :street1
  end
end
