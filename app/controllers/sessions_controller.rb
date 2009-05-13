class SessionsController < ApplicationController
  
  skip_before_filter :login_required, :only => %w(new create)
  
  layout 'login'
  
  def new
  end
  
  def create
    subscriber = Subscriber.authenticate(params[:login], params[:password])
    if subscriber
      session[:subscriber_id] = subscriber.id
      redirect_to_target_or_default(root_url)
    else
      flash.now[:warning] = "Invalid login or password."
      render :action => 'new'
    end
  end
  
  def destroy
    session[:subscriber_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
  
end
