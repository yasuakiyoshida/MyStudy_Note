class LearningComment < ApplicationRecord
  belongs_to :user
  belongs_to :learning

  validates :comment, presence: true
end
