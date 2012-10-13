class Script < ActiveRecord::Base
  belongs_to :delivery_method

  validates :script_type, :presence => true
  validates :script, :presence => true
  validates :delivery_method_id, :presence => true
end
