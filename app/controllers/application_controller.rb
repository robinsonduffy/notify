class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def page_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  rescue_from CanCan::AccessDenied do |exception|
    deny_access
  end

end
