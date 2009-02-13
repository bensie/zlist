class Mailman < ActionMailer::Base
  
  def receive(email)
    
    sender_address, sender_domain = email.to.first.split(/\@/)
    sender_list, sender_topic_key, sender_subscriber_key = sender_address.split(/\+/)

    # Ensure emails are not being sent to the mailer or noreply addresses.  Do nothing if that's the case.
    if sender_list == "mailer" || sender_list == "noreply"
      exit
    end
    
    verified_list = List.find_by_short_name(sender_list)
    
    # Make sure the list exists
    if verified_list
      verified_sender = verified_list.subscribers.find_by_public_key(sender_subscriber_key)
      verified_topic = verified_list.topics.find_by_key(sender_topic_key)
      
      # If the sender is not a subscriber, let them know they can't send
      unless verified_sender.present?
        deliver_cannot_post(verified_list, email.from)
        exit
      end
      
      # Check if this is a response to an existing topic or a new message
      if sender_address =~ /\+/
        unless verified_topic.present?
          deliver_no_such_topic(verified_list, email.from)
          exit
        end
        
        # Clean up the subject line
        email.subject = email.subject.gsub(/\[#{verified_list.name}\]/, "")   # Remove the name of the list
        email.subject = email.subject.gsub(/([rR][eE]:\ *){2,}/, "RE: ")      # Remove any RE's and FW's
        
      else
        verified_topic = verified_list.topics.create(:name => email.subject)
      end
      
      message = verified_topic.messages.build(:subject => email.subject, :body => email.body)
      message.author = verified_sender
      message.save
      
      verified_list.subscribers.each do |subscriber|
        deliver_send_to_mailing_list(verified_topic, email, message.author, subscriber)
      end
      
    else
      deliver_no_such_list(sender_email)
      exit
    end
  end

  # Send a test e-mail to everyone on a given list
  # pre: list (a List object) 
  def list_test_dispatch(list)
    list.subscribers.each do |subscriber|
      recipients  subscriber.name + " <#{subscriber.email}>" 
      from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
      subject     "[#{list.name}] Test Mailing"
      content_type  "text/html"
    end
  end

  protected

  # Response to a message posted to a list that doesn't exist
  # pre: email (as passed from ActionMailer receieve) 
  def no_such_list(email)
    recipients  email.from
    from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "Address does not exist at this server"
  end

  # Response to a message posted in reply to a tpoic that doesn't exist
  # pre: email (as passed from ActionMailer receieve) 
  def no_such_topic(list, email)
    recipients  email.from
    from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "[#{list.name} The topic you referenced no longer exists"
    body        :list => email.list.name
  end

  # Reponse to a message posted to a list by a non-member
  # pre: email (as passed from ActionMailer receieve) 
  def cannot_post(list, email)
    recipients  email.from
    from        "#{ APP_CONFIG[:email_domain] } <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "[#{list.name}] You're not allowed to post to this list"
    body        :list => list.name
  end

  # Send an e-mail out to a list
  # pre: email (as passed from ActionMailer receieve) 
  def send_to_mailing_list(topic, email, author, subscriber)
    recipients  subscriber.name + " <#{subscriber.email}>"
    from        "#{author.name} <mailer@#{ APP_CONFIG[:email_domain] }>"
    reply_to    "mailer@#{ APP_CONFIG[:email_domain] } <#{list.short_name}+#{topic.key}+#{subscriber.public_key}@" +
                  APP_CONFIG[:email_domain] + ">"
    subject     "[#{list.name}] #{email.subject}"
    body        email.body
    headers     'List-ID' => "#{list.short_name}@#{ APP_CONFIG[:email_domain]}",
                'List-Post' => "#{list.short_name}@#{ APP_CONFIG[:email_domain]}",
                'List-Unsubscribe' => "http://#{ APP_CONFIG[:email_domain] }/list/#{ list.id }/unsubscribe"
  end


end
