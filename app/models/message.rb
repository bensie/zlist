class Message < ActiveRecord::Base
  # Association: a belongs_to association means that there must be a foreign key
  # in this table for the specified belongs_to columns.  In this case, it expects
  # topic_id and subscriber_id columns in the "messages" table.  When calling a
  # message, we can access the topics and subscriber with:
  # Message.topic or Message.subscriber.  You can chain these methods infinitely as
  # long as the associations exist.
  belongs_to :topic
  belongs_to :author, :class_name => 'Subscriber'
end
