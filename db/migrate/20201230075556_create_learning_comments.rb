class CreateLearningComments < ActiveRecord::Migration[5.2]
  def change
    create_table :learning_comments do |t|
      t.integer :user_id
      t.integer :learning_id
      t.text :comment

      t.timestamps
    end
  end
end
