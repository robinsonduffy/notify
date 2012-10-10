class RecipientType < ActiveRecord::Base
  has_many :recipients

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end
