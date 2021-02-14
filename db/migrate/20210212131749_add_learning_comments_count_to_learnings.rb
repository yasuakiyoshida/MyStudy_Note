class AddLearningCommentsCountToLearnings < ActiveRecord::Migration[5.2]
  def self.up
    add_column :learnings, :learning_comments_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :learnings, :learning_comments_count
  end
end
