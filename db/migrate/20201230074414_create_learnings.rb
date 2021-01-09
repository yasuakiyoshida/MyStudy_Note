class CreateLearnings < ActiveRecord::Migration[5.2]
  def change
    create_table :learnings do |t|
      t.integer :user_id
      t.string :title
      t.string :image_id
      t.text :detail
      t.datetime :start_date_time
      t.datetime :end_date_time
      t.boolean :is_public

      t.timestamps
    end
  end
end
