class List < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :contact_methods

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :description, :presence => true
  validates :user_id, :presence => true
end