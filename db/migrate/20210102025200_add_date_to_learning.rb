class AddDateToLearning < ActiveRecord::Migration[5.2]
  def change
    add_column :learnings, :date, :date
  end
end
