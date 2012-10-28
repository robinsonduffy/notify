class GroupsController < ApplicationController
  authorize_resource

  def index
    @groups = Group.order(:name)
    @title = "Groups"
  end

  def new
    @group = Group.new()
    @title = "Create New Group"
  end

  def create
    @group = current_user.groups.build(params[:group])
    if @group.save
      #group created
      flash[:success] = "Group '#{@group.name}' successfully created."
      redirect_to groups_path
    else
      #there was an error
      @title = "Create New Group"
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
    @title = "Group Detail"
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      flash[:success] = "Group '#{@group.name}' updated."
      redirect_to groups_path
    else
      @title = "Group Detail"
      render :show
    end
  end

  def destroy
    group = Group.find(params[:id]).destroy
    flash[:notice] = "Group '#{group.name}' deleted."
    redirect_to groups_path
  end

end
