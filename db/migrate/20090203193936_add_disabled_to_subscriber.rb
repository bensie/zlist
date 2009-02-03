class AddDisabledToSubscriber < ActiveRecord::Migration
  def self.up
    add_column :subscribers, :disabled, :boolean, :default => 0
  end

  def self.down
    remove_column :subscribers, :disabled
  end
end
