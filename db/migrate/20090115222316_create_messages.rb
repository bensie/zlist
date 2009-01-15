class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :topic_id
      t.string  :subject
      t.string  :body
      t.integer :subscriber_id

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
