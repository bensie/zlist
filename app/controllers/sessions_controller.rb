class SessionsController < ApplicationController
  
  skip_before_filter :login_required, :only => %w(new create)
  def new
  end
  
  def create
    subscriber = Subscriber.authenticate(params[:login], params[:password])
    if subscriber
      session[:subscriber_id] = subscriber.id
      flash[:notice] = "Logged in successfully."
      redirect_back_or_default('/')
    else
      flash.now[:error] = "Invalid login or password."
      render :action => 'new'
    end
  end
  
  def destroy
    session[:subscriber_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
  
  protected

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
