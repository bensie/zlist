class EmailsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :only => %w(create)
  skip_before_filter :login_required, :only => %w(create)

  before_filter :admin_required, :only => %w(test)
  before_filter :verify_sender_can_send_email, :only => %w(create)

  def create
    Mailman.receive(params[:email])
    
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
    #server = Server.find_by_key!(params[:key])
    #unless request.env['REMOTE_ADDR'] == server.ip
    #  respond_to do |format|
    #    format.html { redirect_to root_url }
    #    format.xml { render :xml => 'Go pound sand', :status => :unprocessable_entity }
    #  end
    #end
    
    # Put temporary validation code here
  end
end
