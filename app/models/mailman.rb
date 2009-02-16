class Mailman < ActionMailer::Base
  
#   bcc                     BCC addresses for the message
#   body                    Define the body of the message. This is either a Hash 
#                               (in which case it specifies the variables to pass to the template when it is rendered), 
#                               or a string, in which case it specifies the actual text of the message.
#   cc 	                    CC addresses for the message.
#   charset                 Charset to use for the message. This defaults to the default_charset 
#                               specified for ActionMailer::Base.
#   content_type            Content type for the message. This defaults to <text/plain in most cases, 
#                               but can be automatically set in some situations.
#   from                    From address for the message.
#   reply_to                Address (if different than the “from” address) to direct replies to this message.
#   headers                 Additional headers to be added to the message.
#   implicit_parts_order    Specify the order in which parts should be sorted, based on content-type. 
#                               This defaults to the value for the default_implicit_parts_order.
#   mime_version            Defaults to “1.0”, but may be explicitly given if needed.
#   recipient               The recipient addresses for the message, either as a string (for a single address) 
#                             or an array (for multiple addresses).
#   sent_on                 The date on which the message was sent. If not set (the default), the 
#                             header will be set by the delivery agent.
#   subject                 Specify the subject of the message.
#   template                Specify the template name to use for current message. This is the “base” template name, 
#                             without the extension or directory, and may be used to have multiple mailer methods share 
#                             the same template.

  # Method for processing incoming messages
  # pre: (Tmail email)
  def receive(email)
    # Extract out <list>+<thread>@<domain>
    s_list, s_topic, s_domain = 
      email.to.first.match(/^([\w\-]+)\+?([0-9a-f]*)\@([\w\.]+)$/).to_a[1..3]


    # Don't storm if using BCC method with To: noreply 
    # TODO: remove 
    if(s_list == "mailer" || s_list == "noreply")
      exit
    end

    # Make sure the list exists
    unless(List.exists?(:short_name => s_list))
      Mailman.deliver_no_such_list(email)
      exit
    end

    list = List.find_by_short_name(s_list)

    # Make sure they are in the list (allowed to post)
    unless(list.subscribers.exists?(:email => email.from))
      Mailman.deliver_cannot_post(list, email)
      exit
    end

    # Check if this is a response to an existing topic or a new message
    if(s_topic.length > 0) 
      unless(Topic.exists?(:key => s_topic)) 
        Mailman.deliver_no_such_topic(list, email)
        exit
      end

      topic = Topic.find_by_key(s_topic)

      # Strip out the subject crap
      # Can't use gsub! because subject isn't actually a string unless coerced
      email.subject = email.subject.gsub(/\[#{list.short_name}\]/, "")
      # Clean out RE and FW's
      email.subject = email.subject.gsub(/([rR][eE]:\ *){2,}/, "RE: ")

    else
      topic = list.topics.create(
        :name => email.subject
        )
    end

    # Todo: move multipart parsing here, add html and plain to message model

    message = topic.messages.build(:subject => email.subject, :body => email.body)
    message.author = Subscriber.find_by_email(email.from)
    message.save

    if(email.multipart?)
      # Do some list-wide logic
    end
    
    list.subscribers.each do |subscriber|
      Mailman.deliver_to_mailing_list(topic, email, subscriber, message) unless subscriber == message.author
    end

  end

  # Send a test e-mail to everyone on a given list
  # pre: (List list)
  def list_test_dispatch(list)
    list.subscribers.each do |subscriber|
      recipients  subscriber.name + " <#{subscriber.email}>" 
      from        "#{ APP_CONFIG[:email_domain] } <noreply@#{ APP_CONFIG[:email_domain] }>"
      subject     "[#{list.short_name}] Test Mailing"
    end
  end


  protected

  # Response to a message posted to a list that doesn't exist
  # pre: (TMail email)
  def no_such_list(email)
    recipients  email.from
    from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "Address does not exist at this server"
    body        :address => email.to
  end

  # Response to a message posted in reply to a tpoic that doesn't exist
  # pre: (List list, Tmail email)
  def no_such_topic(list, email)
    recipients  email.from
    from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "[#{list.name}] The topic you referenced no longer exists"
    body        :list => list.name
  end

  # Response to a message sent to a noreply address
  # pre: (Tmail email)
  def no_reply_address(email)
    recipients  email.from
    from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "Replies to this address are not monitored."
    body        "We're sorry, but the addresses noreply@#{ APP_CONFIG[:email_domain] } and mailer@#{ APP_CONFIG[:email_domain] }
                are not monitored for replies.  Your message has been discarded."
  end

  # Reponse to a message posted to a list by a non-member
  # pre: (List list, Tmail email)
  def cannot_post(list, email)
    recipients  email.from
    from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "[#{list.name}] You're not allowed to post to this list"
    body        :list => list.name
  end

  # Send an e-mail out to a list
  # pre: (Topic topic, Tmail email, Subscriber subscriber, Message message)
  def to_mailing_list(topic, email, subscriber, message)
    recipients  subscriber.name + " <#{subscriber.email}>"
    from        "#{message.author.name} <mailer@#{ APP_CONFIG[:email_domain] }>"
    reply_to    "mailer@#{ APP_CONFIG[:email_domain] } <#{topic.list.short_name}+#{topic.key}@" +
                  APP_CONFIG[:email_domain] + ">"
    if topic.list.subject_prefix.present?
      subject     topic.list.subject_prefix + " " + email.subject
    else
      subject     email.subject
    end

    if(email.multipart?)
      content_type "multipart/alternative"
      email.parts.each do |p| 
        if p.content_type == "text/plain"
          part :content_type => "text/plain",
            :body => p.body
        elsif p.content_type == "text/html"
          part :content_type => "text/html",
            :body => p.body
        end 
      end
    else
      body        email.body
    end

    headers     'List-ID' => "#{topic.list.email}",
                'List-Post' => "#{topic.list.email}",
                'List-Unsubscribe' => "http://#{topic.list.domain}/list/#{ topic.list.id }/unsubscribe"
  end


end
