class SubscribersController < ApplicationController
  
  skip_before_filter :login_required, :only => %w(new create)
  before_filter :admin_required, :only => %w(index destroy disable toggle_administrator)
  before_filter :find_subscriber, :only => %w(show edit update destroy disable toggle_administrator)
  
  def index
    @subscribers = Subscriber.active
  end

  def show
  end

  def new
    @subscriber = Subscriber.new
    render :layout => 'login' if !logged_in?
  end

  def edit
  end

  def create
    @subscriber = Subscriber.new(params[:subscriber])
    if @subscriber.save
      if logged_in? && admin?
        flash[:notice] = 'Subscriber was successfully created.'
        redirect_to @subscriber
      else
        flash[:notice] = 'Thanks for signing up!  You are now logged in.'
        session[:subscriber_id] = @subscriber.id
        redirect_back_or_default('/')
      end
    else
      if logged_in?
        render :action => "new"
      else
        render :action => "new", :layout => "login"
      end
    end
  end

  def update
    @subscriber.attributes = params[:subscriber]
    if params[:subscriber][:password].present? || params[:subscriber][:password_confirmation].present?
      @subscriber.saving_password = true
    end
    if @subscriber.save
      flash[:notice] = 'Subscriber was successfully updated.'
      redirect_to(@subscriber)
    else
      render :action => "edit"
    end
  end

  def destroy
    if @subscriber == current_user
      flash[:warning] = 'You can\'t delete yourself.  If you really want to go, have another admin delete you.'
    else
      @subscriber.destroy
    end
    redirect_to(subscribers_url)
  end
  
  def disable
    @subscriber.disable
    redirect_to(subscribers_url)
  end
  
  def toggle_administrator
    @subscriber.update_attribute(:admin, params[:subscriber][:admin]) unless @subscriber == current_user
    respond_to do |format|
      format.js { head :ok }
    end
  end
  
  protected
  
  def find_subscriber
    if admin?
      @subscriber = Subscriber.find(params[:id])
    else
      @subscriber = current_user
    end
  end
end
