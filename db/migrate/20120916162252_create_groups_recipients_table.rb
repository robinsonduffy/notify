class CreateGroupsRecipientsTable < ActiveRecord::Migration
  def self.up
    create_table :groups_recipients, :id => false do |t|
      t.references :group
      t.references :recipient
    end
    add_index :groups_recipients, [:group_id, :recipient_id]
    add_index :groups_recipients, [:recipient_id, :group_id]
  end

  def self.down
    drop_table :groups_recipients
  end
end
