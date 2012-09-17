class LinkedRecipient < ActiveRecord::Base

  belongs_to :parent, :class_name => "Recipient"
  belongs_to :student, :class_name => "Recipient"

  validates :student_id, :presence => true
  validates :parent_id, :presence => true

end
