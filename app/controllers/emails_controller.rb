class EmailsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => %w(create)
  skip_before_filter :login_required, :only => %w(create)

  before_filter :verify_server_can_send_email, :only => %w(create)

  def create
    Mailman.receive(params[:email])
    render :nothing => true
  end

  private

  def verify_server_can_send_email
    unless Server.find_by_key(params[:key])
      render :text => "Your server did not provide a valid key to post messages.", :status => 403
    end
  end
end
