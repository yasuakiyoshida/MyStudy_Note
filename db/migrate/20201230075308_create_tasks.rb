class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.text :detail
      t.integer :priority_status
      t.datetime :due
      t.integer :progress_status

      t.timestamps
    end
  end
end
