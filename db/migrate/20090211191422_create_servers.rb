class CreateServers < ActiveRecord::Migration
  def self.up
    create_table :servers do |t|
      t.string :name
      t.string :ip
      t.string :key

      t.timestamps
    end
  end

  def self.down
    drop_table :servers
  end
end
