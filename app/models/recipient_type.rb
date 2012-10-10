class RecipientType < ActiveRecord::Base
  has_many :recipients, :dependent => :destroy
  has_many :message_permissions, :as => :object, :dependent => :destroy
  has_many :message_recipients, :as => :object, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end
