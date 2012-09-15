class UsersController < ApplicationController
  authorize_resource

  def show
    @user = User.find(params[:id])
    @title = "User Detail"
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
    if(params[:ldap] == 'true')
      @user.password = 'ldap'
    end
    if(@user.save)
      #user created
      redirect_to(@user)
    else
      #there wasn an error
      @title = "Create New User"
      render(:new)
    end
  end

  def save_roles
    authorize!(:manage, User)
    @user = User.find(params[:user_id])
    if params[:roles_to_set].empty?
      @user.roles=[""]
    else
      @user.roles=params[:roles_to_set].split(',')
    end
    if(@user == current_user)
      unless @user.roles.include?("admin")
        @user.roles=params[:roles_to_set].split(',').push("admin")
      end
    end
    if(@user.save)
      render :nothing => true
    else
      page_not_found
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

end
