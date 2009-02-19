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
    @subscription = Subscription.new(params[:subscription])
    @list = @subscription.list
    respond_to do |format|
      if @subscription.save
        @subscriptions = Subscription.all(:conditions => ['list_id = ?', @subscription.list_id])
        @available_subscribers = Subscriber.find_subscribers_not_in_list(@subscription.list_id)
        format.html { redirect_to(list_path(@subscription.list)) }
        format.xml  { render :xml => @subscription, :status => :created, :location => @subscription }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @subscription.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = 'Subscription was successfully updated.'
      redirect_to(@subscription)
    else
      render :action => "edit"
    end
  end

  def destroy
    @list = @subscription.list
    @subscription.destroy
    
    @subscriptions = Subscription.all(:include => :subscriber, :conditions => ['list_id = ?', @list.id])
    @available_subscribers = Subscriber.find_subscribers_not_in_list(@list.id)
    respond_to do |format|
      format.html { redirect_to memberships_url }
      format.xml  { head :ok }
      format.js {}
    end
  end
  
  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
