class Schedule < ActiveRecord::Base
  belongs_to :message

  validates :message_id, :presence => true
  validates :delivery_time, :presence => true
end
