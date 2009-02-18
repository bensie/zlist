class AddSomeOptionsToLists < ActiveRecord::Migration
  def self.up
    add_column :lists, :archive_disabled, :boolean, :default => false
    add_column :lists, :disabled, :boolean, :default => false
    add_column :lists, :message_footer, :string
    add_column :lists, :custom_footer_text, :text
    add_column :lists, :send_replies_to, :string
    add_column :lists, :permitted_to_post, :string
    
    List.all.each do |list|
      list.message_footer = 'None'
      list.send_replies_to = 'Subscribers'
      list.permitted_to_post = 'Subscribers'
      list.save
    end
  end

  def self.down
    remove_column :lists, :archive_disabled
    remove_column :lists, :disabled
    remove_column :lists, :message_footer
    remove_column :lists, :custom_footer_text
    remove_column :lists, :send_replies_to
    remove_column :lists, :permitted_to_post
  end
end
