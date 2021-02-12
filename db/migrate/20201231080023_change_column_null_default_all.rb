class ChangeColumnNullDefaultAll < ActiveRecord::Migration[5.2]
  def change
    change_column_null :favorites, :user_id, false
    change_column_null :favorites, :learning_id, false

    change_column_null :learning_comments, :user_id, false
    change_column_null :learning_comments, :learning_id, false
    change_column_null :learning_comments, :comment, false

    change_column_null :tasks, :user_id, false
    change_column_null :tasks, :title, false
    change_column_null :tasks, :priority_status, false
    change_column :tasks, :priority_status, :integer, default: 0
    change_column_null :tasks, :due, false
    change_column_null :tasks, :progress_status, false
    change_column :tasks, :progress_status, :integer, default: 0

    change_column_null :learnings, :user_id, false
    change_column_null :learnings, :title, false
    change_column_null :learnings, :start_date_time, false
    change_column_null :learnings, :end_date_time, false
    change_column_null :learnings, :is_public, false
    change_column :learnings, :is_public, :boolean, default: true

    change_column_null :users, :nickname, false
  end
end
