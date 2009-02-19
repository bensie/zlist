class ListsController < ApplicationController
  
  before_filter :admin_required, :except => %w(index show subscribe unsubscribe available)
  before_filter :find_list, :only => %w(show edit send_test update destroy subscribe unsubscribe)

  def index
    @lists = admin? ? List.all(:include => :subscribers, :order => :name) : current_user.lists(:order => :name)
  end
  
  def available
    @lists = List.public(:order => :name)
  end

  def show
    @subscription = Subscription.new
    @available_subscribers = Subscriber.find_subscribers_not_in_list(@list.id)
  end

  def new
    @list = List.new
  end

  def edit
  end

  def create
    @list = List.new(params[:list])
    if @list.save
      flash[:notice] = 'List was successfully created.'
      redirect_to(@list)
    else
      flash.now[:warning] = 'There was a problem creating the list.'
      render :action => "new"
    end
  end

  def update
    if @list.update_attributes(params[:list])
      flash[:notice] = 'List was successfully updated.'
      redirect_to(@list)
    else
      flash.now[:warning] = 'There was a problem updating the list.'
      render :action => "edit" 
    end
  end

  def destroy
    @list.destroy
    flash[:notice] = "The list was deleted."
    redirect_to(lists_url)
  end

  def send_test
    Mailman.deliver_list_test_dispatch(@list) unless @list.subscriptions.blank?
    redirect_to(@list)
  end

  def subscribe
   @list.subscribers << current_user
   flash[:notice] = 'Subscriber added.'
   redirect_to(lists_url)
  end

  def unsubscribe
    @list.subscribers.delete(current_user)
    flash[:notice] = 'Subscriber removed.'
    redirect_to(lists_url)
  end

  protected
  
  def find_list
    @list = List.find(params[:id])
  end
end
