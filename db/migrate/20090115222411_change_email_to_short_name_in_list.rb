class ChangeEmailToShortNameInList < ActiveRecord::Migration
  def self.up
    rename_column :lists, :email, :short_name
  end

  def self.down
    rename_column :lists, :short_name, :email
  end
end
