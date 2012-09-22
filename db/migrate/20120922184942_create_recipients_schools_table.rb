class CreateRecipientsSchoolsTable < ActiveRecord::Migration
  def self.up
    create_table :recipients_schools, :id => false do |t|
      t.references :recipient
      t.references :school
    end
    add_index :recipients_schools, [:school_id, :recipient_id]
    add_index :recipients_schools, [:recipient_id, :school_id]
  end

  def self.down
    drop_table :recipients_schools
  end
end
