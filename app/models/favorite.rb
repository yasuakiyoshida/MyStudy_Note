class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :learning
  counter_culture :learning, touch: true

  validates_uniqueness_of :learning_id, scope: :user_id
end
