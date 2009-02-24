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
      if request.request_uri.match(/\/subscribe/)
        flash[:notice] = "You need to login or create an account before subscribing to this list"
      elsif request.request_uri.match(/\/unsubscribe/)
        flash[:notice] = "Please login to unsubscribe from this list"
      else
        flash[:notice] = "You need to login or create an account first, then we'll send you right along..."
      end
      store_location
      redirect_to login_url
    end
  end
  
  private
  
  def store_location
    session[:return_to] = request.request_uri
  end
end
