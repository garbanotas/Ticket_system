class AddOwnerToIssues < ActiveRecord::Migration
  def self.up
  	add_column :issues, :owner_id, :integer
  end

  def self.down
  	remove_column :issues, :owner_id
  end
end
