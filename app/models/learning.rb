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
  
  def self.week_study_time
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    week_learnings = self.where(date: from...to)
    self.learning_time_sum(week_learnings)
  end
  
  def self.month_study_time
    to = Time.current.at_end_of_day
    from = (to - 1.month).at_beginning_of_day
    month_learnings = self.where(date: from...to)
    self.learning_time_sum(month_learnings)
  end
  
  def self.learning_time_sum(date_ranges)
    total_time = 0
    date_ranges.each { |date_range| total_time += date_range.time }
    total_time.floor(1)
  end
end