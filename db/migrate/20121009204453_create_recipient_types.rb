class CreateRecipientTypes < ActiveRecord::Migration
  def self.up
    create_table :recipient_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :recipient_types
  end
end
