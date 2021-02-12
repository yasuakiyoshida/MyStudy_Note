class LearningComment < ApplicationRecord
  belongs_to :user
  belongs_to :learning

  delegate :nickname, to: :user, prefix: true

  validates :comment, presence: true
end
