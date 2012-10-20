class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest

    if @user.id.nil?
      send(:guest)
    else
      send(:user)
      @user.roles.each { |role| send(role.gsub(' ','_')) }
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def guest
    can :access, :sessions
    can :view, :content
  end

  def user
    #all users are automatically assigned this role
    guest
    can :view, :protected_content
  end

  #special roles
  def system_admin
    #full control over everything
    #Not meant for non-technical users
    system_manager
    can :assign, :system_admins
  end

  def system_manager
    #superusers  Have access to most of the system, but not the overly technical stuff
    #They can manage users
    #meant for people who need their egos stroked but don't need access to the dangerous stuff
    recipient_manager
    can :manage, User
  end

  def location_manager
    #maintain a location
    #can manage lists and groups for their location(s)
    #meant for principals or admin secretaries
    full_sender
  end

  def full_sender
    #can send to any group/list for their location(s)
    #cannot create lists/groups
  end

  def limited_sender
    #can only send to specific groups/lists for their locations(s)
  end

  def recipient_manager
    #maintains recipients
    recipient_viewer
  end

  def recipient_viewer
    #can view full recipient data, but cannot edit it
  end

end
