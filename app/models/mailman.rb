class Mailman < ActionMailer::Base

  # Method for processing incoming messages
  # pre: email (as passed from ActionMailer receieve) 
  def receive(email)
    s_list, s_topic = email.subject.split(/\+/)

    # Make sure the list exists
    unless(List.exists?(:name => s_list))
      deliver_no_such_list(email)
      exit
    end

    list = List.find_by_name(s_list)

    # Add virtual fields for other functions to use
    email.list = list


    # Make sure they are in the list (allowed to post)
    unless(list.recipients.exists?(:email => email.from))
      deliver_cannot_post(email)
      exit
    end

    # Check if this is a response to an existing topic or a new message
    if(email.subject =~ /\+/) then
      unless(topic.exists?(:key => topic.key)) then
        deliver_no_such_topic(email)
      end

      topic = Topic.find_by_key(topic.key)

    else
      topic = list.topics.create(
        :subject => email.subject
        )
    end

    # Add virtual fields for other functions to use
    email.topic = topic

    message = topic.messages.create(
      :subject => email.subject,
      :body => email.body,
      :from => email.from,
      :content_type => email.content_type
      )

    deliver_list_dispatch(email)

  end

  # Send a test e-mail to everyone on a given list
  # pre: list (a List object) 
  def list_test_dispatch(list)
    # Don't try to proceed if there are no subscribers
    if(list.subscribers.empty?)
      return false
    end

    r = Array.new
    list.subscribers.each { |x| r.push(x.email) }

    recipients  "noreply@lists.loni.ucla.edu"
    bcc         list.subscribers.map(&:email)
    from        "dList <mailer@lists.loni.ucla.edu"
    subject     "[#{list.name}] Test Mailing"

    return true
  end

  protected

  # Response to a message posted to a list that doesn't exist
  # pre: email (as passed from ActionMailer receieve) 
  def no_such_list(email)
    recipients  email.from
    from        "dList <mailer@lists.loni.ucla.edu"
    subject     "Address does not exist at this server"
    body        :list => email.list.name
  end

  # Response to a message posted in reply to a tpoic that doesn't exist
  # pre: email (as passed from ActionMailer receieve) 
  def no_such_topic(email)
    recipients  email.from
    from        "dList <mailer@lists.loni.ucla.edu"
    subject     "[#{email.list.name} The topic you referenced no longer exists"
    body        :list => email.list.name
  end

  # Reponse to a message posted to a list by a non-member
  # pre: email (as passed from ActionMailer receieve) 
  def cannot_post(email)
    recipients  email.from
    from        "dList <mailer@lists.loni.ucla.edu"
    subject     "[#{email.list.name}] You're not allowed to post to this list"
    body        :list => email.list.name
  end

  # Send an e-mail out to a list
  # pre: email (as passed from ActionMailer receieve) 
  def list_dispatch(email)
    r = Array.new
    email.list.subscribers.each { |x| r.push(x.email) }

    recipients  "noreply@lists.loni.ucla.edu"
    bcc         r
    from        "#{email.from} <#{email.list.name}+#{email.topic.key}@lists.loni.ucla.edu"
    subject     "#{email.list.name} #{email.subject}"
    body        email.body
  end


end
