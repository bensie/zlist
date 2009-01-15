class Mailman < ActionMailer::Base
  def receive(email)
    s_list, s_topic = email.subject.split(/\+/)

    # Make sure the list exists
    unless(List.exists?(:name => s_list))
      deliver_no_such_list(email)
      exit
    end

    list = List.find_by_name(s_list)

    # Add these virtual fields for other functions to use
    #email.s_list = s_list
    #email.s_topic = s_list
    email.list = list


    unless(list) then
      deliver_no_such_list(email)
      exit
    end

    # Make sure they are in the list (allowed to post)
    unless(list.recipients.exists?(:email => email.from))
      deliver_cannot_post(email)
      exit
    end

    # Check if this is a response to an existing topic or a new message
    if(email.subject =~ /\+/ then
      unless(topic.exists?(:key => s_topic)) then
        deliver_no_such_topic(email)
      end

      topic = Topic.find_by_key(s_topic)
    else
      topic = list.topics.create(
        :subject => email.subject
        )
    end

    email.topic = topic

    message = topic.messages.create(
      :subject => email.subject,
      :body => email.body,
      :from => email.from,
      :content_type => email.content_type
      )

    deliver_list_dispatch(email)

  end


  def list_test_dispatch(list)
    r = Array.new
    list.each { |x| r.push(x.email) }

    recipients  "noreply@lists.loni.ucla.edu"
    bcc         r
    from        "dList <mailer@lists.loni.ucla.edu"
    subject     "[#{list.name}] Test Mailing"
  end

protected:

  def no_such_list(email)
    recipients  email.from
    from        "dList <mailer@lists.loni.ucla.edu"
    subject     "Address does not exist at this server"
    body        :list => email.list.name
  end

  def cannot_post(email)
    recipients  email.from
    from        "dList <mailer@lists.loni.ucla.edu"
    subject     "[#{email.list.name}] You're not allowed to post to this list"
    body        :list => email.list.name
  end

  def list_dispatch(email)
    r = Array.new
    email.list.each { |x| r.push(x.email) }

    recipients  "noreply@lists.loni.ucla.edu"
    bcc         r
    from        "#{email.from} <#{email.list.name}+#{email.topic.key}@lists.loni.ucla.edu"
    subject     "#{email.list.name} #{email.subject}"
    body        email.body
  end


end
