class DeliveryMethod < ActiveRecord::Base
  belongs_to :message
  belongs_to :contact_method_type
  belongs_to :from_method
  has_many :scripts, :dependent => :destroy

  validates :message_id, :presence => true
  validates :contact_method_type_id, :presence => true
  validates :from_method_id, :presence => true
end
