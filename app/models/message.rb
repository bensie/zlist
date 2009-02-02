class Message < ActiveRecord::Base
  # Association: a belongs_to association means that there must be a foreign key
  # in this table for the specified belongs_to columns.  In this case, it expects
  # topic_id and subscriber_id columns in the "messages" table.  When calling a
  # message, we can access the topics and subscriber with:
  # Message.topic or Message.subscriber.  You can chain these methods infinitely as
  # long as the associations exist.
  belongs_to :topic
  belongs_to :author, :class_name => 'Subscriber', :foreign_key => 'subscriber_id'

  # Return message body without signatures or inline replies
  def body_clean
    text = ""

    # Iterate through each line
    body.split(/\n/).each do |line|
      # Included replies "> some text"
      next if line.match(/^>+/) 
      next if line.match(/On.*wrote:/)
      # Outlook reply style
      break if line.match(/-{4,}Original Message-{4,}/)
      # Signature break "--"
      break if line.match(/^\s*\-{2,}\s*$/)
      # Lines with only whitespace - blank them
      line.gsub(/^\s+$/, "")

      text += line + "\n"
    end

    # Clean out multiple line breaks throughout (longer than one blank line)
    text.gsub!(/\n{3,}/, "\n\n")  
    # Clean up multiple line breaks at end (none)
    text.gsub!(/\n{2,}$/, "\n")

    return text
  end

end
