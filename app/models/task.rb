class Task < ApplicationRecord
  belongs_to :user
  
  enum priority_status: { 高: 0, 中: 1, 低: 2 }
  enum progress_status: { 未着手: 0, 処理中: 1, 完了: 2, 保留: 3 }
  
end