class UsersController < ApplicationController
  authorize_resource :except => [:assign_user_message_permissions, :change_password]

  def show
    @user = User.find(params[:id])
    @title = "User Detail"
  end

  def update
    #raise params.inspect
    @user = User.find(params[:id])
    @user.roles = params[:roles]
    if @user.update_attributes(params[:user])
      #CREATE USER PERMISSIONS
      assign_user_message_permissions
      flash[:success] = "User info updated"
      redirect_to @user
    else
      @title = "User Detail"
      render :show
    end
  end

  def index
    @title = "Users"
    @users = User.order(:name)
  end

  def destroy
    delete_user = User.find(params[:id])
    if delete_user == current_user
      redirect_to root_path
    else
      delete_user.destroy
      flash[:success] = "User #{delete_user.username} deleted"
      redirect_to users_path
    end
  end

  def new
    @title = "Create New User"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.roles = params[:roles]
    if params[:ldap] == 'true'
      @user.password = 'ldap'
    end
    if @user.save
      #user created
      #CREATE USER PERMISSION LINKS
      assign_user_message_permissions
      flash[:success] = "User successfully created."
      redirect_to @user
    else
      #there was an error
      @title = "Create New User"
      render :new
    end
  end

  def change_password
    authorize!(:manage, User)
    if params[:password].to_s.empty?
      flash[:error] = "You can't have a blank password"
      redirect_to user_path(:id => params[:user_id]) and return
    end
    user = User.find(params[:user_id])
    if user.password == 'ldap'
      flash[:error] = "This user authenticated through ldap.  You can't change their password."
      redirect_to user_path(:id => params[:user_id]) and return
    end
    user.password = params[:password]
    user.encrypt_password
    if user.save
      flash[:success] = "Password Changed"
    else
      flash[:error] = "There was an error.  The password was not changed."
    end
    redirect_to user_path(:id => params[:user_id])
  end


  private
    def assign_user_message_permissions
      authorize!(:create, User)
      current_permissions = Array.new
      #SCHOOLS
      params[:user_schools] = [''] if params[:user_schools].nil?
      params[:user_schools].each do |school_id|
        (current_permissions << @user.message_permissions.find_or_create_by_object_type_and_object_id('School', school_id).id) unless school_id.blank?
      end
      #MESSAGETYPES
      params[:user_message_types] = [''] if params[:user_message_types].nil?
      params[:user_message_types].each do |message_type_id|
        (current_permissions << @user.message_permissions.find_or_create_by_object_type_and_object_id('MessageType', message_type_id).id) unless message_type_id.blank?
      end
      #CONTACT_METHOD_TYPES
      params[:user_contact_method_types] = [''] if params[:user_contact_method_types].nil?
      params[:user_contact_method_types].each do |contact_method_type_id|
        (current_permissions << @user.message_permissions.find_or_create_by_object_type_and_object_id('ContactMethodType', contact_method_type_id).id) unless contact_method_type_id.blank?
      end
      #LISTS
      params[:user_lists] = [''] if params[:user_lists].nil?
      params[:user_lists].each do |list_id|
        (current_permissions << @user.message_permissions.find_or_create_by_object_type_and_object_id('List', list_id).id) unless list_id.blank?
      end
      #GROUPS
      params[:user_groups] = [''] if params[:user_groups].nil?
      params[:user_groups].each do |group_id|
        (current_permissions << @user.message_permissions.find_or_create_by_object_type_and_object_id('Group', group_id).id) unless group_id.blank?
      end
      #RECIPIENT_TYPES
      params[:user_recipient_types] = [''] if params[:user_recipient_types].nil?
      params[:user_recipient_types].each do |recipient_type_id|
        (current_permissions << @user.message_permissions.find_or_create_by_object_type_and_object_id('RecipientType', recipient_type_id).id) unless recipient_type_id.blank?
      end
      #DELETE OLD USER MESSAGE PERMISSIONS
      @user.message_permissions.where("id NOT IN (#{current_permissions.join(',')})").delete_all
    end
end
