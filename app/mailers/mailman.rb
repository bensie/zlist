class Mailman < ActionMailer::Base

  def receive(email)
    # Extract out <list>+<thread>@<domain>
    sender_list, sender_topic, sender_domain = email.to.first.match(/^([\w\-]+)\+?([0-9a-f]*)\@([\w\.]+)$/).to_a[1..3]

    # Make sure the list exists
    list = List.find_by_short_name(sender_list)
    unless list.present?
      Mailman.deliver_no_such_list(email)
      exit
    end

    # Make sure the sender is in the list (allowed to post)
    author = list.subscribers.find_by_email(email.from)
    unless author.present?
      Mailman.deliver_cannot_post(list, email)
      exit
    end

    # Check if this is a response to an existing topic or a new message
    if sender_topic.present?
      topic = Topic.find_by_key(sender_topic)
      unless topic.present?
        Mailman.deliver_no_such_topic(list, email)
        exit
      end

      # Reset the subject so it doesn't contain the prefix
      email.subject = topic.name

    else
      topic = list.topics.create(:name => email.subject)
    end

    # Store the message
    message = topic.messages.create(:subject => email.subject, :body => email.body, :author => author)

    # Deliver to subscribers
    list.subscribers.each do |subscriber|
      Mailman.deliver_to_mailing_list(topic, email, subscriber, message) unless subscriber == message.author
    end

  end

  # Send a test to the list
  def list_test_dispatch(list)
    list.subscribers.each do |subscriber|
      mail(
        :to      =>  "#{subscriber.name} <#{subscriber.email}>",
        :from    => "#{ ENV['email_domain'] } <noreply@#{ ENV['email_domain'] }>",
        :subject => "[#{list.short_name}] Test Mailing"
      )
    end
  end

  private

  # Response to a message posted to a list that doesn't exist
  def no_such_list(email)
    @address = email.to
    mail(
      :to =>  email.from,
      :from       =>  "#{ ENV['email_domain'] } <mailer@#{ ENV['email_domain'] }>",
      :subject    =>  "Address does not exist at this server"
    )
  end

  # Response to a message posted in reply to a topic that doesn't exist
  def no_such_topic(list, email)
    @list = list.name
    mail(
      :to      => email.from,
      :from    => "#{ ENV['email_domain'] } <mailer@#{ ENV['email_domain'] }>",
      :subject => "[#{list.name}] The topic you referenced no longer exists"
    )
  end

  # Response to a message sent to a noreply address
  def no_reply_address(email)
    mail(
      :to      => email.from,
      :from    => "#{ ENV['email_domain'] } <mailer@#{ ENV['email_domain'] }>",
      :subject => "Replies to this address are not monitored.",
      :body    => "We're sorry, but the addresses noreply@#{ ENV['email_domain'] } and mailer@#{ ENV['email_domain'] }
                  are not monitored for replies.  Your message has been discarded."
    )
  end

  # Reponse to a message posted to a list by a non-member
  def cannot_post(list, email)
    @list = list.name
    mail(
      :to      => email.from,
      :from    => "#{ ENV['email_domain'] } <mailer@#{ ENV['email_domain'] }>",
      :subject => "[#{list.name}] You're not allowed to post to this list"
    )
  end

  # Send an e-mail out to a list
  def to_mailing_list(topic, email, subscriber, message)

    # Determine the reply-to address
    case topic.list.send_replies_to
    when "Subscribers"
      reply_to = "mailer@#{ ENV['email_domain'] } <#{topic.list.short_name}+#{topic.key}@" + ENV['email_domain'] + ">"
    when "Author"
      reply_to = "#{message.author.name} <#{message.author.email}>"
    end

    # Determine the subject
    if topic.list.subject_prefix.present?
      subject = [topic.list.subject_prefix, email.subject].join(" ")
    else
      subject = email.subject
    end

    # Determine content_type
    if email.multipart?
      content_type "multipart/alternative"
      email.parts.each do |p|
        if p.content_type == "text/plain"
          part :content_type => "text/plain", :body => p.body
        elsif p.content_type == "text/html"
          part :content_type => "text/html", :body => p.body
        end
      end
    else
      body email.body
    end

    # Set additional headers
    headers['List-ID']          = topic.list.email
    headers['List-Post']        = topic.list.email
    headers['List-Unsubscribe'] = "http://#{topic.list.domain}/lists/#{ topic.list.id }/unsubscribe"

    mail(
      :to       =>  "#{subscriber.name} <#{subscriber.email}>",
      :from     =>"#{message.author.name} <mailer@#{ ENV['email_domain'] }>",
      :reply_to => reply_to,
      :subject  => subject
    )
  end

end
