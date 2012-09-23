class ContactMethod < ActiveRecord::Base
  belongs_to :recipient
  has_many :delivery_options
  has_and_belongs_to_many :lists

  validates :contact_method_type, :presence => true,
            :uniqueness => {:scope => [:recipient_id, :delivery_route]}
  validates :delivery_route, :presence => true
end
