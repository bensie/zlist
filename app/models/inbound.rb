module Inbound

  class Email

    attr_accessor :subject, :to, :from, :headers, :html_body, :text_body, :attachments

    def initialize(email)
      @subject      = email.fetch("Subject")
      @to           = email.fetch("To")
      @from         = email.fetch("From")
      @headers      = email.fetch("Headers").map{|h| Header.new(h)}
      @html_body    = email.fetch("HtmlBody")
      @text_body    = email.fetch("TextBody")
      @attachments  = email.fetch("Attachments").map{|a| Attachment.new(a)}
      @reply_to     = email.fetch("ReplyTo")
      @message_id   = email.fetch("MessageID")
      @mailbox_hash = email.fetch("MailboxHash")
      @mailbox      = email.fetch("To").split("+").first
    end

  end

  class Attachment

    attr_accessor :content, :content_length, :content_type, :name

    def initialize(attachment)
      @content        = attachment.fetch("Content")
      @content_length = attachment.fetch("ContentLength")
      @content_type   = attachment.fetch("ContentType")
      @name           = attachment.fetch("Name")
    end

  end

  class Header

    attr_accessor :name, :value

    def initialize(header)
      @name  = header.fetch("Name")
      @value = header.fetch("Value")
    end

  end

end
