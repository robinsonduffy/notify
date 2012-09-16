class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :groups, :user_id
  end

  def self.down
    drop_table :groups
  end
end
