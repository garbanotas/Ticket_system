class AddStateToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :state, :string
  end
   def self.down
    remove_column :issues, :state
  end
end
