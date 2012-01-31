class InboundEmailProcessor
  @queue = :email

  def self.perform(request_body)
    hash = ActiveSupport::JSON.decode(request_body)
    Inbound::Email.new(hash).process
  rescue Exception => e
    p e
  end
end
