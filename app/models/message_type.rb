class MessageType < ActiveRecord::Base
  has_many :message_permissions, :as => :object, :dependent => :destroy
  has_and_belongs_to_many :delivery_options
  has_many :messages, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end
