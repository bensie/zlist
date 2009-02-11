class EmailsController < ApplicationController
  def create
    # Place holder for real server authentication
    if(params[:key] == "abcdefg")
      Mailman.receive(params[:email])
      flash[:notice] = 'E-mail was ingested'
    else
      flash[:warning] = 'Server authentication failed'
    end

    respond_to do |format|
      format.html { redirect_to :action => "test" }
      format.xml 
    end

  end
  # Just for sending a test e-mail
  def test
  end
end
