class RecipientsController < ApplicationController
  authorize_resource

  def index
    @title = "Recipients"
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
