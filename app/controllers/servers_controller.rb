class ServersController < ApplicationController

  before_filter :admin_required
  before_filter :find_server, :only => %w(show edit update destroy)

  respond_to :html

  def index
    @servers = Server.order(:name)
  end

  def show
    redirect_to [:edit, @server]
  end

  def new
    @server = Server.new
  end

  def create
    @server = Server.create(params[:server])
    respond_with @server, location: servers_path
  end

  def edit
  end

  def update
    @server.update_attributes(params[:server])
    respond_with @server, location: servers_path
  end

  def destroy
    @server.destroy
    respond_with @server
  end

  private

  def find_server
    @server = Server.find(params[:id])
  end

end
