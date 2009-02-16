class AddSubjectLineToLists < ActiveRecord::Migration
  def self.up
    add_column :lists, :subject_prefix, :string
  end

  def self.down
    remove_column :lists, :subject_prefix
  end
end
