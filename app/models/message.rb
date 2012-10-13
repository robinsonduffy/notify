class Message < ActiveRecord::Base
  has_many :message_recipients, :dependent => :destroy
  belongs_to :user
  belongs_to :message_type
  has_many :delivery_methods, :dependent => :destroy


end
