class TopicsController < ApplicationController
  before_filter :find_topic, :only => %w(show edit update destroy)

  def index
    @topics = Topic.all
  end

  def show
  end

  def new
    @topics = Topic.new
  end

  def edit
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      flash[:notice] = 'Topic was successfully created.'
      redirect_to(@topic)
    else
      flash.now[:warning] = 'There was a problem creating the topic.'
      render :action => "new"
    end
  end

  def update
    if @topic.update_attributes(params[:topic])
      flash[:notice] = 'Topic was successfully updated.'
      redirect_to(@topic)
    else
      flash.now[:warning] = 'There was a problem updating the topic.'
      render :action => "edit" 
    end
  end

  def destroy
    @topic.destroy
    flash[:notice] = "The topic was deleted."
    redirect_to(topics_url)
  end

  protected
  
  def find_topic
    @topic = Topic.find(params[:id])
  end

end
