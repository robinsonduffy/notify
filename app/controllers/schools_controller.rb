class SchoolsController < ApplicationController
  authorize_resource

  def index
    @schools = School.order(:name)
    @title = "Schools"
  end

  def new
    @school = School.new()
    @title = "Create New School"
  end

  def create
    @school = School.new(params[:school])
    if @school.save
      #school created
      flash[:success] = "School successfully created."
      redirect_to @school
    else
      #there was an error
      @title = "Create New School"
      render :new
    end
  end

  def show
    @school = School.find(params[:id])
    @title = "School Detail"
  end

  def update
    @school = School.find(params[:id])
    if @school.update_attributes(params[:school])
      flash[:success] = "School info updated"
      redirect_to @school
    else
      @title = "School Detail"
      render :show
    end
  end

  def destroy
    school = School.find(params[:id]).destroy
    flash[:notice] = "School '#{school.name}' deleted."
    redirect_to schools_path
  end
end
