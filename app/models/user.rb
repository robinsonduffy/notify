# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  password   :string(255)
#  name       :string(255)
#  admin      :boolean
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :groups
  has_many :lists
  has_many :message_permissions, :dependent => :destroy

  attr_accessible :username, :password, :name, :admin
  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :password, :presence => true

  default_scope :order => 'users.username ASC'

  before_create :encrypt_password

  ##ROLES##
  ROLES = ['admin'] #ALWAYS ADD NEW ROLES ON THE END!

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  ##End of ROLES##

  def has_password?(submitted_password)
    password == secure_hash(submitted_password)
  end

  def User.authenticate(username, submitted_password)
    user = User.find_by_username(username)
    if(user.nil?)
      #no user in database
      #for now, we will return nil
      return nil
      #return User.ldap_lookup(username, submitted_password)
    else
      if(user.password == 'ldap')
        #this user is an ldap user so we need to check that password
        #for now, we will return nil
        return nil
        #return User.ldap_lookup(username, submitted_password)
      else
        return user if user.has_password?(submitted_password)
      end
    end

  end

  def encrypt_password
    if(self.password != 'ldap')
      self.password = secure_hash(self.password)
    end
  end

  private
    def User.ldap_lookup(username, submitted_password)
      if(username.blank? || submitted_password.blank?)
        return nil
      end
      ldap = Net::LDAP.new
      ldap.host = '172.16.10.15'
      ldap.port = 389
      ldap.auth "cn=#{username},ou=Staff,dc=fsd,dc=domain", submitted_password
      if ldap.bind
        ldap_data = ldap.search(
            :base => "ou=Staff,dc=fsd,dc=domain",
            :filter => Net::LDAP::Filter.eq( "cn", username ),
            :attributes => ["givenName", "sn"],
            :return_result => true
        ).first
        if(User.find_by_username(username).nil?)
          #the user doesn't exist, so let's create one
          #return User.create!(:username => username, :password => 'ldap', :name => "#{ldap_data.givenName.first} #{ldap_data.sn.first}")
          #OR the user doesn't exist...so don't let them in (uncomment the line below and comment the line above)
          return nil
        else
          #the user is already in here...let's just log them in
          ldap_user = User.find_by_username(username)
          ldap_user.update_attribute('name', "#{ldap_data.givenName.first} #{ldap_data.sn.first}")
          return ldap_user
        end
        # authentication succeeded
      else
        error = ldap.get_operation_result
        return nil
        # authentication failed
      end
    end

    def secure_hash(string)
       Digest::SHA2.hexdigest(string)
    end

end
