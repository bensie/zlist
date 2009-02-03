class SubscribersController < ApplicationController
  
  skip_before_filter :login_required, :only => %w(new create)
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
      session[:subscriber_id] = @subscriber.id
      flash[:notice] = 'Subscriber was successfully created.'
      redirect_to(root_url)
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
    @subscriber.destroy
    redirect_to(subscribers_url)
  end
  
  def disable
    @subscriber.disable
    redirect_to(subscribers_url)
  end
  
  protected
  
  def find_subscriber
    @subscriber = Subscriber.find(params[:id])
  end
end
