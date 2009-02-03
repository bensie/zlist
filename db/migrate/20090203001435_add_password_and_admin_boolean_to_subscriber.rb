class AddPasswordAndAdminBooleanToSubscriber < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :password_hash, :string
    add_column :subscribers, :password_salt, :string
    add_column :subscribers, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :subscribers, :password_hash
    remove_column :subscribers, :password_salt
    remove_column :subscribers, :admin
  end
end
