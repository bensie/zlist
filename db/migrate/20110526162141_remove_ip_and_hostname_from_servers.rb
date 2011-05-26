class RemoveIpAndHostnameFromServers < ActiveRecord::Migration
  def up
    remove_column :servers, :ip
    remove_column :servers, :hostname
  end

  def down
    add_column :servers, :ip, :string
    add_column :servers, :hostname, :string
  end
end
