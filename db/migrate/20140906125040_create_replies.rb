class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.belongs_to :issue, index: true
      t.belongs_to :author, index: true
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
