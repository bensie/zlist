class Mailman < ActionMailer::Base

  # Send a test to the list
  def list_test_dispatch(list)
    list.subscribers.each do |subscriber|
      mail(
        :to      =>  "#{subscriber.name} <#{subscriber.email}>",
        :from    => "#{ ENV['EMAIL_DOMAIN'] } <noreply@#{ ENV['EMAIL_DOMAIN'] }>",
        :subject => "[#{list.short_name}] Test Mailing"
      )
    end
  end

  # Response to a message posted to a list that doesn't exist
  def no_such_list(email)
    @address = email.to
    mail(
      :to      =>  email.from,
      :from    =>  "#{ ENV['EMAIL_DOMAIN'] } <mailer@#{ ENV['EMAIL_DOMAIN'] }>",
      :subject =>  "Address does not exist at this server"
    )
  end

  # Response to a message posted in reply to a topic that doesn't exist
  def no_such_topic(list, email)
    @list = list.name
    mail(
      :to      => email.from,
      :from    => "#{ ENV['EMAIL_DOMAIN'] } <mailer@#{ ENV['EMAIL_DOMAIN'] }>",
      :subject => "[#{list.name}] The topic you referenced no longer exists"
    )
  end

  # Response to a message sent to a noreply address
  def no_reply_address(email)
    mail(
      :to      => email.from,
      :from    => "#{ ENV['EMAIL_DOMAIN'] } <mailer@#{ ENV['EMAIL_DOMAIN'] }>",
      :subject => "Replies to this address are not monitored.",
      :body    => "We're sorry, but the addresses noreply@#{ ENV['EMAIL_DOMAIN'] } and mailer@#{ ENV['EMAIL_DOMAIN'] }
                  are not monitored for replies.  Your message has been discarded."
    )
  end

  # Reponse to a message posted to a list by a non-member
  def cannot_post(list, email)
    @list = list.name
    mail(
      :to      => email.from,
      :from    => "#{ ENV['EMAIL_DOMAIN'] } <mailer@#{ ENV['EMAIL_DOMAIN'] }>",
      :subject => "[#{list.name}] You're not allowed to post to this list"
    )
  end

  # Send an e-mail out to a list
  def to_mailing_list(topic, email, subscriber, message)

    # Determine the reply-to address
    case topic.list.send_replies_to
    when "Subscribers"
      reply_to = "mailer@#{ ENV['EMAIL_DOMAIN'] } <#{topic.list.short_name}+#{topic.key}@" + ENV['EMAIL_DOMAIN'] + ">"
    when "Author"
      reply_to = "#{message.author.name} <#{message.author.email}>"
    end

    # Determine the subject
    if topic.list.subject_prefix.present?
      subject = [topic.list.subject_prefix, email.subject].join(" ")
    else
      subject = email.subject
    end

    # Set additional headers
    headers['List-ID']          = topic.list.email
    headers['List-Post']        = topic.list.email
    headers['List-Unsubscribe'] = "http://#{topic.list.domain}/lists/#{ topic.list.id }/unsubscribe"

    mail(
      :to       => "#{subscriber.name} <#{subscriber.email}>",
      :from     => "#{message.author.name} <mailer@#{ ENV['EMAIL_DOMAIN'] }>",
      :reply_to => reply_to,
      :subject  => subject
    ) do |format|
      format.text { render :text => email.text_body } if email.text_body.present?
      format.html { render :text => email.html_body } if email.html_body.present?
    end
  end

end
