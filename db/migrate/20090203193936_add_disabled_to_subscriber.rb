class AddDisabledToSubscriber < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :disabled, :boolean, :default => false
  end

  def self.down
    remove_column :subscribers, :disabled
  end
end
