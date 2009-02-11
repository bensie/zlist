class ServersController < ApplicationController
  
  before_filter :admin_required
  before_filter :find_server, :only => %w(show edit update destroy) 
  
  def index
    @servers = Server.all(:order => :name)
  end

  def show
  end

  def new
    @server = Server.new
  end

  def create
    @server = Server.new(params[:server])
    if @server.save
      flash[:notice] = 'Server was successfully created.'
      redirect_to(@server)
    else
      flash.now[:warning] = 'There was a problem creating the server.'
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @server.update_attributes(params[:server])
      flash[:notice] = 'Server was successfully updated.'
      redirect_to(@server)
    else
      render :action => "edit"
    end
  end

  def destroy
    @server.destroy
    redirect_to :back
  end
  
  protected
  
  def find_server
    @server = Server.find(params[:id])
  end

end
