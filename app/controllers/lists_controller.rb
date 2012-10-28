class ListsController < ApplicationController

  def index
    authorize! :read, List
    @lists = List.order(:name)
    @title = "Manage Lists"
  end

  def new
    authorize! :create, List
    @list = List.new()
    @title = "Create New List"
  end

  def create
    authorize! :create, List #can they create a list?
    @list = current_user.lists.build(params[:list])
    authorize! :create, @list #can they create THIS exact list?
    if @list.save
      #from_method created
      flash[:success] = "List '#{@list.name}' successfully created."
      redirect_to lists_path
    else
      #there was an error
      @title = "Create New List"
      render :new
    end
  end

  def show
    @list = List.find(params[:id])
    authorize! :show, @list
    @title = "List Detail"
  end

  def update
    @list = List.find(params[:id])
    authorize! :update, @list
    if @list.update_attributes(params[:list])
      #update the schools as well
      flash[:success] = "List '#{@list.name}' successfully updated."
      redirect_to lists_path
    else
      @title = "List Detail"
      render :show
    end
  end

  def destroy
    list = List.find(params[:id])
    authorize! :destroy, list
    list.destroy
    flash[:notice] = "List '#{list.name}' deleted."
    redirect_to lists_path
  end
end
