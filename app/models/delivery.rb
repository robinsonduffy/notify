class Delivery < ActiveRecord::Base
  belongs_to :delivery_method
  has_one :message, :through => :delivery_method
  belongs_to :contact_method
  has_one :recipient, :through => :contact_method
  has_many :audio_segments

  DELIVERY_RESULTS = ['','success']

  validates :delivery_method_id, :presence => true
  validates :contact_method_id, :presence => true
  validates :delivered_message, :presence => true
  validates :delivery_result, :presence => true, :inclusion => {:in => 1..(Delivery::DELIVERY_RESULTS.length - 1)}
end
