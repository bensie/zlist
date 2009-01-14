class CreateThreads < ActiveRecord::Migration
  def self.up
    create_table :threads do |t|
      t.integer :list_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :threads
  end
end
