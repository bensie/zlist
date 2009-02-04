class ListsShouldNotBePrivateByDefault < ActiveRecord::Migration
  def self.up
    change_column :lists, :private, :boolean, :default => false
  end

  def self.down
    change_column :lists, :private, :boolean, :default => true
  end
end
