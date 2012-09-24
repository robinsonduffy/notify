class Group < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :recipients
  has_many :message_permissions, :as => :object, :dependent => :destroy

  validates :name, :presence => true,
                   :uniqueness => {:case_sensitive => false}
  validates :user_id, :presence => true
end
