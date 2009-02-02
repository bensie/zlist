class Mailman < ActionMailer::Base

  # Method for processing incoming messages
  # pre: email (as passed from ActionMailer receieve) 
  def receive(email)
    # TODO: clean up with regexp and logic 

    s_pre, s_domain = email.to.first.split(/\@/)
    s_list, s_topic = s_pre.split(/\+/)

    # Don't storm
    if(s_list == "mailer" || s_list == "noreply")
      exit
    end

    # Make sure the list exists
    unless(List.exists?(:short_name => s_list))
      Mailman.deliver_no_such_list(email)
      exit
    end

    list = List.find_by_short_name(s_list)

    # Add virtual fields for other functions to use
    #email.list = list


    # Make sure they are in the list (allowed to post)
    unless(list.subscribers.exists?(:email => email.from))
      Mailman.deliver_cannot_post(list, email)
      exit
    end

    # Check if this is a response to an existing topic or a new message
    if(s_pre =~ /\+/) then
      unless(Topic.exists?(:key => s_topic)) then
        Mailman.deliver_no_such_topic(list, email)
      end

      topic = Topic.find_by_key(s_topic)

      # Strip out the subject crap
      email.subject.gsub!(/\[#{list.short_name}\]/, "")

    else
      topic = list.topics.create(
        :name => email.subject
        )

      topic.key = sprintf("%08d", topic.id)
      topic.save
    end

    # Add virtual fields for other functions to use
    #email.topic = topic

    message = topic.messages.create(
      :subject => email.subject,
      :body => email.body
      )

    # This isn't working
    message.author = Subscriber.find_by_email(email.from)
      #:content_type => email.content_type
      #:from => email.from
    message.save

    Mailman.deliver_list_dispatch(list, topic, email)

  end

  # Send a test e-mail to everyone on a given list
  # pre: list (a List object) 
  def list_test_dispatch(list)
      recipients  "noreply@" + APP_CONFIG[:email_domain]
      bcc         list.subscribers.map(&:email)
      from        "dList <mailer@#{ APP_CONFIG[:email_domain] }>"
      subject     "[#{list.name}] Test Mailing"
  end


  protected

  # Response to a message posted to a list that doesn't exist
  # pre: email (as passed from ActionMailer receieve) 
  def no_such_list(email)
    recipients  email.from
    from        "dList <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "Address does not exist at this server"
  end

  # Response to a message posted in reply to a tpoic that doesn't exist
  # pre: email (as passed from ActionMailer receieve) 
  def no_such_topic(list, email)
    recipients  email.from
    from        "dList <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "[#{list.name} The topic you referenced no longer exists"
    body        :list => email.list.name
  end

  # Reponse to a message posted to a list by a non-member
  # pre: email (as passed from ActionMailer receieve) 
  def cannot_post(list, email)
    recipients  email.from
    from        "dList <mailer@#{ APP_CONFIG[:email_domain] }>"
    subject     "[#{list.name}] You're not allowed to post to this list"
    body        :list => list.name
  end

  # Send an e-mail out to a list
  # pre: email (as passed from ActionMailer receieve) 
  def list_dispatch(list, topic, email)
    # Don't try to proceed if there are no subscribers
    if(list.subscribers.empty?)
      return false
    end

    # Temporary: use prefix before domain as from
    email.from.to_s.match(/(.*)@/)
    disp_from = $1;

    recipients  "#{list.short_name} subscribers <noreply@#{ APP_CONFIG[:email_domain] }>"
    bcc         list.subscribers.map(&:email)
  # Example: dph <david_list+e7e8b099@lists.funtaff.com>
    from        "#{disp_from} <mailer@#{ APP_CONFIG[:email_domain] }>"
    reply_to    "#{email.from} <#{list.short_name}+#{topic.key}@" +
                  APP_CONFIG[:email_domain] + ">"

    subject     "[#{list.short_name}] #{email.subject}"
    body        email.body
    headers     'List-ID' => "#{list.short_name}@#{ APP_CONFIG[:email_domain]}",
                'List-Post' => "#{list.short_name}@#{ APP_CONFIG[:email_domain]}",
                'List-Unsubscribe' => "http://#{ APP_CONFIG[:email_domain] }/list/#{ list.short_name }/unsubscribe"
  end


end
