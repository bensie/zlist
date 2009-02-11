class EmailsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => %w(create)
  skip_before_filter :login_required, :only => %w(create)

  before_filter :admin_required, :only => %w(test)
  before_filter :verify_server_can_send_email, :only => %w(create)

  def create
    Mailman.receive(params[:email])
    # For test action
    flash[:notice] = 'E-mail was ingested'
    
    # Probably want a catch here incase Mailman throws an error

    respond_to do |format|
      format.html { redirect_to :action => "test" }
      format.xml 
    end
  end

  # Just for sending a test e-mail
  def test
  end
  
  protected
  
  def verify_server_can_send_email
    server = Server.find_by_ip!(request.env['REMOTE_ADDR'])

    # Let them use a universal key if they aren't in the database
    unless ( params[:key] == server.key ) || ( params[:key] == "abcdefg" )
      # Remove warning when system ironed out
      flash[:warning] = 'Server authentication failed'
      respond_to do |format|
        format.html { redirect_to root_url }
        format.xml { render :xml => 'Go pound sand', :status => :unprocessable_entity }
      end
    end

  end
end
