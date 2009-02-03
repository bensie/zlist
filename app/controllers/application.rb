class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time

  protect_from_forgery
  
  before_filter :login_required
  
  protected
  
  def admin_required
    unless logged_in? && current_user.admin?
      flash[:warning] = "You must be an administrator to access this page."
      redirect_to root_url
    end
  end

end
