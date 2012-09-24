class MessagePermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, :polymorphic => true

  validates :user_id, :presence => true, :uniqueness => [:scope => [:object_id, :object_type], :case_sensitive => true]
  validates :object_type, :presence => true
  validates :object_id, :presence => true
end
