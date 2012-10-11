class MessageRecipient < ActiveRecord::Base
  belongs_to :message
  belongs_to :object, :polymorphic => true

  validates :message_id, :presence => true, :uniqueness => [:scope => [:object_id, :object_type], :case_sensitive => false]
  validates :object_type, :presence => true
  validates :object_id, :presence => true
end
