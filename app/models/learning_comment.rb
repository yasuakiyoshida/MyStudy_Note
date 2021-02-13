class LearningComment < ApplicationRecord
  belongs_to :user
  belongs_to :learning
  counter_culture :learning, touch: true

  delegate :nickname, to: :user, prefix: true

  validates :comment, presence: true
end
