class School < ActiveRecord::Base

  has_and_belongs_to_many :recipients

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end
