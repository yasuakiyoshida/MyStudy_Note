class Task < ApplicationRecord
  include EnumHelpRansack
  belongs_to :user
  acts_as_taggable

  enum priority_status: { 高: 0, 中: 1, 低: 2 }
  enum progress_status: { 未着手: 0, 処理中: 1, 完了済: 2, 保留中: 3 }

  validates :title, presence: true
  validates :due, presence: true
  validate :due_cannot_be_in_the_past, on: :create
  
  def due_cannot_be_in_the_past
    if due.presence && due < Time.now
      errors.add(:due, "に過去の日時を設定することはできません")
    end
  end
end
