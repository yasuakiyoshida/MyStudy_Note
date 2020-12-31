class Task < ApplicationRecord
  belongs_to :user
  
  enum priority_status: { high: 0, middle: 1, low: 2 }
  enum progress_status: { new_task: 0, in_progress: 1, completed: 2, pending: 3 }
end
