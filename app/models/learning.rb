class Learning < ApplicationRecord
  belongs_to :user
  has_many :learning_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  attachment :image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.today_study_time
    today_learnings = self.where(date: Date.today)
    self.learning_time_sum(today_learnings)
  end

  def self.yesterday_study_time
    yesterday_learnings = self.where(date: Date.yesterday)
    self.learning_time_sum(yesterday_learnings)
  end

  def self.learning_time_sum(date_ranges)
    total_time = 0
    date_ranges.each do |date_range|
      total_time += date_range.time
    end
    total_time.floor(1)
  end
  
end