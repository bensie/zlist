class AddHostnameToServers < ActiveRecord::Migration
  def self.up
    add_column :servers, :hostname, :string
  end

  def self.down
    remove_column :servers, :hostname
  end
end
