class SubscriptionsController < ApplicationController
  
  before_filter :find_subscription, :only => %w(show edit update destroy)
  
  def index
    @subscriptions = Subscription.find(:all)
  end

  def show
  end

  def new
    @subscription = Subscription.new
  end

  def edit
  end

  def create
  end

  def update
    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = 'Subscription was successfully updated.'
      redirect_to(@subscription)
    else
      render :action => "edit" }
    end
  end

  def destroy
    @subscription.destroy
    redirect_to :back
  end
  
  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
