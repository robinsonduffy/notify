class AddSchoolIdToList < ActiveRecord::Migration
  def self.up
    add_column :lists, :school_id, :integer
    add_index :lists, :school_id
  end

  def self.down
    remove_index :lists, :school_id
    remove_column :lists, :school_id
  end
end
