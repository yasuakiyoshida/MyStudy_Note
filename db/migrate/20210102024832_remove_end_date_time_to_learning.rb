class RemoveEndDateTimeToLearning < ActiveRecord::Migration[5.2]
  def change
    remove_column :learnings, :end_date_time, :datetime
  end
end
