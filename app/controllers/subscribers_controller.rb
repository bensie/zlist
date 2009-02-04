class SubscribersController < ApplicationController
  
  skip_before_filter :login_required, :only => %w(new create)
  before_filter :admin_required, :only => %w(index destroy disable)
  before_filter :find_subscriber, :only => %w(show edit update destroy)
  
  def index
    @subscribers = Subscriber.active
  end

  def show
  end

  def new
    @subscriber = Subscriber.new
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
        redirect_to(root_url)
      end
    else
      render :action => "new"
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
  
  protected
  
  def find_subscriber
    if admin?
      @subscriber = Subscriber.find(params[:id])
    else
      @subscriber = current_user
    end
  end
end
