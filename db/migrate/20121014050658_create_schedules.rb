class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.datetime :delivery_time
      t.references :message

      t.timestamps
    end
    add_index :schedules, :message_id
  end

  def self.down
    drop_table :schedules
  end
end
