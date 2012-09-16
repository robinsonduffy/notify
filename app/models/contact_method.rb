class ContactMethod < ActiveRecord::Base
  belongs_to :recipient

  validates :contact_method_type, :presence => true,
            :uniqueness => {:scope => [:recipient_id, :delivery_route]}
  validates :delivery_route, :presence => true
end
