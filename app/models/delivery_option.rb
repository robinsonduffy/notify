class DeliveryOption < ActiveRecord::Base
  belongs_to :contact_method
  has_and_belongs_to_many :message_types

  validates :option_scope, :presence => true
  validates :scope_id, :presence => true

  scope :own, :conditions => "option_scope = 'self'"
  scope :linked, lambda {|linked_id| {:conditions => "option_scope = 'link' AND scope_id = '#{linked_id}'"}}

  ##OPTIONS##

  scope :for_message_type, lambda { |message_type| {:joins => :message_types, :conditions => "delivery_options_message_types.message_type_id = #{message_type.id}" }}

  def options=(options)
    options.each do |option|
      message_type = MessageType.find_by_name(option.downcase)
      unless self.message_types.include? message_type
        self.message_types<<message_type
      end
    end
    return self.message_types
  end

  ##End of OPTIONS##
end
