class AddVariousIndexes < ActiveRecord::Migration
  def self.up
    add_index :subscriptions, :subscriber_id
    add_index :subscriptions, :list_id
    add_index :topics, :list_id
    add_index :messages, :subscriber_id
    add_index :messages, :topic_id
  end

  def self.down
    remove_index :subscriptions, :subscriber_id
    remove_index :subscriptions, :list_id
    remove_index :topics, :list_id
    remove_index :messages, :subscriber_id
    remove_index :messages, :topic_id
  end
end
