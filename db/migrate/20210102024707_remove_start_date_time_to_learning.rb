class RemoveStartDateTimeToLearning < ActiveRecord::Migration[5.2]
  def change
    remove_column :learnings, :start_date_time, :datetime
  end
end
