class EmailsController < ApplicationController
  # We'll be using server authentication
  skip_before_filter :verify_authenticity_token, :only => %w(create)
  skip_before_filter :login_required, :only => %w(create)
  # Only admins can send a test mail
  before_filter :admin_required, :only => %w(test)

  def create
    # Place holder for real server authentication
    if(params[:key] == "abcdefg")
      Mailman.receive(params[:email])
      flash[:notice] = 'E-mail was ingested'
    else
      flash[:warning] = 'Server authentication failed'
    end

    # Probably want a catch here incase Mailman throws an error

    respond_to do |format|
      format.html { redirect_to :action => "test" }
      format.xml 
    end
  end

  # Just for sending a test e-mail
  def test
  end
end
