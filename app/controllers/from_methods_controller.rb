class FromMethodsController < ApplicationController
  authorize_resource

  def index
    @from_methods = FromMethod.order(:from_method)
    @title = "From Methods"
  end

  def new
    @from_method = FromMethod.new()
    @title = "Create New From Method"
  end

  def create
    @from_method = FromMethod.new(params[:from_method])
    if @from_method.save
      #from_method created
      #save the schools
      @from_method.school_ids = params[:schools]
      flash[:success] = "From Method successfully created."
      redirect_to @from_method
    else
      #there was an error
      @title = "Create New From Method"
      render :new
    end
  end

  def show
    @from_method = FromMethod.find(params[:id])
    @title = "From Method Detail"
  end

  def update
    @from_method = FromMethod.find(params[:id])
    if @from_method.update_attributes(params[:from_method])
      #update the schools as well
      @from_method.school_ids = params[:schools]
      flash[:success] = "From Method info updated."
      redirect_to @from_method
    else
      @title = "From Method Detail"
      render :show
    end
  end

  def destroy
    from_method = FromMethod.find(params[:id]).destroy
    flash[:notice] = "From Method '#{from_method.from_method}' deleted."
    redirect_to from_methods_path
  end

end
