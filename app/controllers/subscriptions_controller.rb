class SubscriptionsController < ApplicationController
  
  before_filter :find_subscription, :only => %w(show edit update destroy)
  before_filter :admin_required
  
  def index
    @subscriptions = Subscription.all
  end

  def show
  end

  def new
    @subscription = Subscription.new
  end

  def edit
  end

  def create
    @subscription = Subscription.create(params[:subscription])
    @list = @subscription.list
    redirect_to :back
  end

  def update
    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = 'Subscription was successfully updated.'
      redirect_to @subscription
    else
      render "edit"
    end
  end

  def destroy
    @list = @subscription.list
    @subscription.destroy
    redirect_to :back
  end
  
  private
  
  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
