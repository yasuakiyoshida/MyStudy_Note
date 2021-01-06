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
  
  # 学習時間を集計するメソッドの取得範囲は現在の日時から1週間(ヶ月・年)前の0:00を指定
  def self.week_study_time
    to = Time.current
    from = (to - 6.day).at_beginning_of_day
    week_learnings = self.where(date: from...to)
    self.learning_time_sum(week_learnings)
  end
  
  def self.month_study_time
    to = Time.current
    from = (1.month.ago + 1.day).at_beginning_of_day
    month_learnings = self.where(date: from...to)
    self.learning_time_sum(month_learnings)
  end
  
  # def self.learning_time_sum(date_ranges)
    # total_time = 0
    # date_ranges.each { |date_range| total_time += date_range.time }
    # total_time.floor(1)
  # end
  
  def self.learning_time_sum(date_ranges)
    date_ranges.inject(0) { |sum, date_range| sum + date_range.time }
  end
  
  def self.learnings_period(period)
    current = Time.current.beginning_of_day
    case period
    when "week"
      start_date = current.ago(6.days)
    when "month"
      start_date = current.ago(1.month - 1.day)
    when "year"
      start_date = current.ago(1.year - 1.day)
    else
      start_date = current.ago(6.days)
    end
    end_date = Time.current
    dates = {}
    (start_date.to_date...end_date.to_date).each do |date|
      learnings = self.where(date: date)
      sum_times = self.learning_time_sum(learnings)
      dates.store(date.to_s, sum_times)
    end
    return dates
  end
end