class AudioSegment < ActiveRecord::Base
  belongs_to :delivery

  validates :audio, :presence => true
  validates :engine, :presence => true
  validates :play_order, :presence => true, :uniqueness => {:scope => :delivery_id}
  validates :delivery_id, :presence => true
end
