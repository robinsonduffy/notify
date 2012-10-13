class FromMethod < ActiveRecord::Base
  has_and_belongs_to_many :schools

  validates :from_method_type, :presence => true
  validates :from_method, :presence => true, :uniqueness => {:scope => :from_method_type, :case_sensitive => false}
end
