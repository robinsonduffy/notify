class FromMethod < ActiveRecord::Base
  has_and_belongs_to_many :schools
  has_many :delivery_methods

  before_validation :strip_from_method
  before_validation :clean_up_phone

  validates :from_method_type, :presence => true
  validates :from_method, :presence => true,
                          :uniqueness => {:scope => :from_method_type, :case_sensitive => false}
  validates :from_method, :format => {:with => email_regex, :message => "must be a valid email address"}, :if => lambda {|o| o.from_method_type == 'email'}
  validates :from_method, :length => {:is => 11, :message => "must be a valid phone number"}, :numericality => {:only_integer => true, :greater_than => 10000000000, :message => "must be a valid phone number"}, :if => lambda {|o| o.from_method_type == 'phone'}
  def strip_from_method
    self.from_method.strip!
  end

  def clean_up_phone
    self.from_method = computerize_phone_number(self.from_method) if self.from_method_type == 'phone'
  end
end
