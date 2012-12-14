class RecipientsController < ApplicationController
  authorize_resource

  def index
    @title = "Recipients"
    @recipients = Recipient.all
  end

  def new
    @recipient = Recipient.new()
    @title = "Create New Recipient"
  end

  def create
    @recipient = Recipient.new(params[:recipient])
    if @recipient.save
      #recipient created
      flash[:success] = "Recipient successfully created."
      redirect_to recipient_path(@recipient)
    else
      #there was an error
      @title = "Create New Recipient"
      render :new
    end
  end

  def show
    @recipient = Recipient.find(params[:id])
    @title = "Recipient Detail"
  end

  def edit
    @recipient = Recipient.find(params[:id])
    @title = "Edit Recipient"
  end

  def update
    @recipient = Recipient.find(params[:id])
    if @recipient.update_attributes(params[:recipient])
      # Save the Parent/Student Links
      params[:recipient_parents] = Array.new if params[:recipient_parents].nil?
      params[:recipient_students] = Array.new if params[:recipient_students].nil?
      @recipient.parent_ids = params[:recipient_parents]
      @recipient.student_ids = params[:recipient_students]
      flash[:success] = "Recipient updated."
      redirect_to recipient_path(@recipient)
    else
      @title = "Edit Recipient"
      render :edit
    end
  end

  def destroy
    recipient = Recipient.find(params[:id]).destroy
    flash[:notice] = "Recipient deleted."
    redirect_to recipients_path
  end
end
