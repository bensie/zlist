class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time

  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :login_required
  
  private
  
  def admin_required
    unless admin?
      redirect_to root_url
    end
  end
  
  def admin?
    logged_in? && current_user.admin?
  end
  helper_method :admin?

end
