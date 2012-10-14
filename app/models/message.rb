class Message < ActiveRecord::Base
  has_many :message_recipients, :dependent => :destroy
  belongs_to :user
  belongs_to :message_type
  has_many :delivery_methods, :dependent => :destroy
  has_many :schedules, :dependent => :destroy

  STATUS = ['','draft']

  validates :name, :presence => true
  validates :status, :presence => true, :inclusion => {:in => 1..(Message::STATUS.length - 1)}
  validates :user_id, :presence => true
end
