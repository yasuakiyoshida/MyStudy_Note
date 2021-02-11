class Task < ApplicationRecord
  include EnumHelpRansack
  belongs_to :user
  acts_as_taggable

  enum priority_status: { 高: 0, 中: 1, 低: 2 }
  enum progress_status: { 未着手: 0, 処理中: 1, 完了済: 2, 保留中: 3 }

  scope :sorted, -> (count) { order("due").per(count) }

  validates :title, presence: true, length: { maximum: 50 }
  validates :due, presence: true
  # updateにもバリデーションつけると過去のToDoリストを編集する際に期限も変えなければならないのでcreateのみ
  validate :due_cannot_be_in_the_past, on: :create

  def due_cannot_be_in_the_past
    if due.presence && due < Time.now
      errors.add(:due, "に過去の日時を設定することはできません")
    end
  end
end
