class UsersController < ApplicationController
  authorize_resource

  def show
    @user = User.find(params[:id])
    @title = "User Detail"
  end

  def update
    @user = User.find(params[:id])
    @user.roles = params[:roles]
    if @user.update_attributes(params[:user])
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

end
