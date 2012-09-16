class Recipient < ActiveRecord::Base

  validates :external_id, :presence => true,
                          :uniqueness => {:scope => :recipient_type, :case_sensitive => false}
  validates :recipient_type, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
end
