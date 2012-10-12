class Message < ActiveRecord::Base
  has_many :message_recipients
  belongs_to :user
  belongs_to :message_type


end
