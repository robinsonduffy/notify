class Recipient < ActiveRecord::Base
  has_and_belongs_to_many :groups
  has_many :contact_methods
  has_many :linked_recipients, :foreign_key => "parent_id",
                               :dependent => :destroy
  has_many :reverse_linked_recipients, :foreign_key => "student_id",
                                       :class_name => "LinkedRecipient",
                                       :dependent => :destroy
  has_many :parents, :through => :reverse_linked_recipients
  has_many :students, :through => :linked_recipients
  has_and_belongs_to_many :schools

  validates :external_id, :presence => true,
                          :uniqueness => {:scope => :recipient_type, :case_sensitive => false}
  validates :recipient_type, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  def add_parent!(parent)
    self.reverse_linked_recipients.create!(:parent_id => parent.id) if parent.is_parent? && self.is_student?
  end

  def add_student!(student)
    self.linked_recipients.create!(:student_id => student.id) if student.is_student? && self.is_parent?
  end

  def is_student?
    self.recipient_type == 'student'
  end

  def is_parent?
    self.recipient_type == 'parent'
  end

  def is_staff?
    self.recipient_type == 'staff'
  end

  def contacts(message_type)
    contacts = Array.new
    # Get our own contact methods
    self.contact_methods.each do |contact_method|
      delivery_option = contact_method.delivery_options.own.with_option(message_type)
      contacts.push contact_method.delivery_route if !delivery_option.empty? || message_type == 'emergency'
    end
    # Get the parents contact methods
    self.parents.each do |parent|
      parent.contact_methods.each do |contact_method|
        delivery_option = contact_method.delivery_options.linked(self.id).with_option(message_type)
        contacts.push contact_method.delivery_route if !delivery_option.empty? || message_type == 'emergency'
      end
    end
    return contacts
  end
end
