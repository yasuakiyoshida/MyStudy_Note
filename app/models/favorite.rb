class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :learning

  validates_uniqueness_of :learning_id, scope: :user_id
end
