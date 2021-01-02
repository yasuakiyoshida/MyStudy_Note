class ChangeColumnNullLearning < ActiveRecord::Migration[5.2]
  def change
    change_column_null :learnings, :date, false
    change_column_null :learnings, :time, false
  end
end
