class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :name
      t.string :email
      t.string :header
      t.string :token
      t.timestamps
    end
  end
end
