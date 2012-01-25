class EmailsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => %w(create)
  skip_before_filter :login_required, :only => %w(create)

  before_filter :verify_server_can_send_email, :only => %w(create)

  def create
    begin
      hash = ActiveSupport::JSON.decode(request.body)
      Inbound::Email.new(hash).process
      render :nothing => true
    rescue MultiJson::DecodeError
      render :text => "Request body must be a JSON hash", :status => 400
    rescue KeyError
      render :text => "Your JSON hash doesn't look like a standard Postmark JSON payload and is missing one or more required attributes"
    end
  end

  private

  def verify_server_can_send_email
    unless Server.find_by_key(params[:key])
      render :text => "Your server did not provide a valid key to post messages.", :status => 403
    end
  end
end
