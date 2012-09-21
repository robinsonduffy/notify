class DeliveryOption < ActiveRecord::Base
  belongs_to :contact_method

  validates :option_scope, :presence => true
  validates :scope_id, :presence => true

  scope :own, :conditions => "option_scope = 'self'"
  scope :linked, lambda {|linked_id| {:conditions => "option_scope = 'link' AND scope_id = '#{linked_id}'"}}

  ##OPTIONS##
  OPTIONS = ['emergency','attendance','outreach'] #ALWAYS ADD NEW OPTIONS ON THE END!

  scope :with_option, lambda { |option| {:conditions => "options_mask & #{2**OPTIONS.index(option.to_s)} > 0 "} }

  def options=(options)
    self.options_mask = (options & OPTIONS).map { |r| 2**OPTIONS.index(r) }.sum
  end

  def options
    OPTIONS.reject { |r| ((options_mask || 0) & 2**OPTIONS.index(r)).zero? }
  end
  ##End of OPTIONS##
end
