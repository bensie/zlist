class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time

  protect_from_forgery
  
  before_filter :login_required
  
  protected
  
  def admin_required
    logged_in? && current_user.admin?
  end

end
