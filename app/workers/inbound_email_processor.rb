class InboundEmailProcessor
  @queue = :email

  def self.perform(json)
    hash = ActiveSupport::JSON.decode(json)
    Inbound::Email.new(hash).process
  end
end
