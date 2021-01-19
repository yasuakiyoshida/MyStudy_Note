class Learning < ApplicationRecord
  belongs_to :user
  has_many :learning_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  acts_as_taggable

  attachment :image

  validates :title, presence: true
  validates :date, presence: true
  validates :time, presence: true, numericality: {less_than_or_equal_to: 24, greater_than: 0}
  validate :date_cannot_be_in_the_future
  validate :total_time_cannot_exceed_24_hours ,on: :create
  # validate :total_time_cannot_exceed_24_hours_for_edit ,on: :update

  def one_day_time_sum(date)
    Learning.where(date: date).sum(:time)
  end

  # learning_idがとれない
  # def one_day_time_sum_unless_target_date(date)
  #   Learning.where(date: date).sum(:time) - Learning.where(date: date).find_by(id: learning.id)[:time]
  # end

  def total_time_cannot_exceed_24_hours
    if date.presence && time.presence && one_day_time_sum(date) + time > 24.0
      errors.add(:date, "：#{date.strftime("%Y年%m月%d日")}の学習時間の合計が24時間を超えています")
    end
  end

  def total_time_cannot_exceed_24_hours_for_edit
    if date.presence && time.presence && one_day_time_sum_unless_target_date(date) + time > 24.0
      errors.add(:date, "：#{date.strftime("%Y年%m月%d日")}の学習時間の合計が24時間を超えています")
    end
  end

  def date_cannot_be_in_the_future
    if date.presence && date > Date.today
      errors.add(:date, "に未来の日付を設定することはできません")
    end
  end

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

  def self.learning_time_sum(date_ranges)
    total_time = date_ranges.inject(0) { |sum, date_range| sum + date_range.time }
    total_time.floor(1)
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