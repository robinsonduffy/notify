class CreateAudioSegments < ActiveRecord::Migration
  def self.up
    create_table :audio_segments do |t|
      t.string :engine
      t.text :audio
      t.integer :play_order
      t.references :delivery

      t.timestamps
    end
    add_index :audio_segments, :delivery_id
    add_index :audio_segments, [:delivery_id, :play_order], :unique => true
  end

  def self.down
    drop_table :audio_segments
  end
end
