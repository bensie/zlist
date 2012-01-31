class InboundEmailProcessor
  @queue = :email

  def self.perform(json)
    hash = ActiveSupport::JSON.decode(request.body)
    Inbound::Email.new(hash).process
  end
end
