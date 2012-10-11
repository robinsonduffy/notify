class ContactMethodType < ActiveRecord::Base
  has_many :contact_methods
  has_many :message_permissions, :as => :object, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end
