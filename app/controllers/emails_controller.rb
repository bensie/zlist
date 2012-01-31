class EmailsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => %w(create)
  skip_before_filter :login_required, :only => %w(create)

  before_filter :verify_server_can_send_email, :only => %w(create)

  def create
    begin
      # Make sure that the request body can be parsed
      ActiveSupport::JSON.decode(request.body.read)

      Resque.enqueue(InboundEmailProcessor, request.body.read)
      render :nothing => true
    rescue MultiJson::DecodeError
      render :text => "Request body must be a JSON hash", :status => 400
    end
  end

  private

  def verify_server_can_send_email
    unless Server.find_by_key(params[:key])
      render :text => "Your server did not provide a valid key to post messages.", :status => 403
    end
  end
end
