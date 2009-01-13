class ListsController < ApplicationController
  
  before_filter :find_list, :only => %w(show edit update destroy)

  def index
    @lists = List.all
  end

  def show
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
      render :action => "new"
    end
  end

  def update
    if @list.update_attributes(params[:list])
      flash[:notice] = 'List was successfully updated.'
      redirect_to(@list)
    else
      render :action => "edit" 
    end
  end

  def destroy
    @list.destroy
    redirect_to(lists_url)
  end
  
  protected
  
  def find_list
    @list = List.find(params[:id])
  end
end