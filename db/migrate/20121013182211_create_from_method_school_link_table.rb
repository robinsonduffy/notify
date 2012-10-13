class CreateFromMethodSchoolLinkTable < ActiveRecord::Migration
  def self.up
    create_table :from_methods_schools, :id => false do |t|
      t.references :from_method
      t.references :school
    end
    add_index :from_methods_schools, [:from_method_id, :school_id]
    add_index :from_methods_schools, [:school_id, :from_method_id]
  end

  def self.down
    drop_table :from_methods_schools
  end
end
