class AddKeyToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :key, :string
  end

  def self.down
    remove_column :topics, :key
  end
end
