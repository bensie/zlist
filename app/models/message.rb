class Message < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
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

  # Return a text representation of how old this is
  # For JAMES: I write these things from scratch to learn ruby, dimwit
  def age

    if(created_at.to_date == Date.today)
      diff = Time.now - created_at.to_time
      if(diff < 60.minutes)
        return pluralize( (diff/60).to_i, "minute") + " ago"
      elsif(diff < 24.hours)
        return pluralize( (diff/(60*60)).to_i, "hour") + " ago"
      end
    elsif(created_at.to_date == Date.yesterday)
      return "yesterday"
    else
      diff = (Date.today - created_at.to_date)*60*60*24
      if(diff < 7.days)
       return pluralize( (diff/(60*60*24)).to_i, "day") + " ago"
      elsif(diff < 1.month)
        return pluralize( (diff/(60*60*24*7)).to_i, "week") + " ago"
      else
        return created_at.to_s
      end
    end 

  end

end
