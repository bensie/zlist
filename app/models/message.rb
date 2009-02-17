class Message < ActiveRecord::Base

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
