class AddTimeToLearning < ActiveRecord::Migration[5.2]
  def change
    add_column :learnings, :time, :float
  end
end
