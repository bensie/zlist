class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time

  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  
  #before_filter :scope_by_domain
  before_filter :login_required
  
  protected
  
  def admin_required
    unless admin?
      redirect_to root_url
    end
  end
  
  def admin?
    logged_in? && current_user.admin?
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  #def scope_by_domain
  #  @current_domain = Domain.find_by_domain_name!(request.subdomains.join('.'))
  #end
end
