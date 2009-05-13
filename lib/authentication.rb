module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?
  end
  
  def current_user
    @current_user ||= Subscriber.find(session[:subscriber_id]) if session[:subscriber_id]
  end
  
  def logged_in?
    current_user
  end
  
  def login_required
    unless logged_in?
      flash[:notice] = "You need to login or create an account to continue."
      store_location
      redirect_to login_url
    end
  end
  
  private
  
  def store_location
    session[:return_to] = request.request_uri
  end
end
