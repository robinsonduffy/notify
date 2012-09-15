class PagesController < ApplicationController

  def home
    authorize!(:view, :protected_content)
    #the main home page
  end


end
