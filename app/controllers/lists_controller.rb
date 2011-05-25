class ListsController < ApplicationController

  before_filter :admin_required, :except => %w(index show subscribe unsubscribe available)
  before_filter :find_list, :only => %w(edit send_test update destroy subscribe unsubscribe)

  respond_to :html, :js

  def index
    @lists = admin? ? List.includes(:subscribers).order('subscribers.name') : current_user.lists.order(:name)
  end

  def available
    @lists = List.public.order(:name)
  end

  def show
    @list = List.find(params[:id])
    @subscriptions = @list.subscriptions.includes(:subscriber).order('subscribers.name')
    @subscription = Subscription.new
    @available_subscribers = Subscriber.find_subscribers_not_in_list(@list.id)
  end

  def new
    @list = List.new
  end

  def edit
  end

  def create
    @list = List.create(params[:list])
    respond_with @list
  end

  def update
    @list.update_attributes(params[:list])
    respond_with @list
  end

  def destroy
    @list.destroy
    respond_with @list
  end

  def send_test
    Mailman.deliver_list_test_dispatch(@list) unless @list.subscriptions.blank?
    redirect_to @list
  end

  def subscribe
   @list.subscribers << current_user
   flash[:notice] = "You're now subscribed to #{@list.name}"
   redirect_to lists_url
  end

  def unsubscribe
    @list.subscribers.delete(current_user)
    flash[:notice] = "You're no longer subscribed to #{@list.name}"
    redirect_to lists_url
  end

  private

  def find_list
    @list = List.find(params[:id])
  end
end
