class School < ActiveRecord::Base
  has_many :message_permissions, :as => :object, :dependent => :destroy
  has_and_belongs_to_many :recipients
  has_many :message_recipients, :as => :object, :dependent => :destroy
  has_and_belongs_to_many :from_methods
  has_many :lists, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end
