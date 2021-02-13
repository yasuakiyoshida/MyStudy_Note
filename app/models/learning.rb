class Learning < ApplicationRecord
  belongs_to :user
  has_many :learning_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  acts_as_taggable

  delegate :nickname, to: :user, prefix: true

  attachment :image

  scope :publish, -> { where(is_public: 1) }
  scope :sorted, -> (count) { reverse_order.per(count) }

  validates :title, presence: true, length: { maximum: 50 }
  validates :date, presence: true
  validates :time, presence: true, numericality: { less_than_or_equal_to: 24, greater_than: 0 }
  validate :date_cannot_be_in_the_future
  validate :total_time_cannot_exceed_limit_time, on: :create
  validate :total_time_cannot_exceed_limit_time_for_edit, on: :update

  # 1日に記録できる学習時間の合計
  LIMIT_TIME_HOUR = 24

  def one_day_time_sum(date)
    user.learnings.where(date: date).sum(:time)
  end

  def one_day_time_sum_unless_target_date(date)
    user.learnings.where(date: date).where.not(id: id).sum(:time)
  end

  def total_time_cannot_exceed_limit_time
    if date.presence && time.presence && one_day_time_sum(date) + time > LIMIT_TIME_HOUR
      errors.add(:date, "：#{date.strftime("%Y年%m月%d日")}の学習時間の合計が24時間を超えています")
    end
  end

  def total_time_cannot_exceed_limit_time_for_edit
    if date.presence && time.presence && one_day_time_sum_unless_target_date(date) + time > LIMIT_TIME_HOUR
      errors.add(:date, "：#{date.strftime("%Y年%m月%d日")}の学習時間の合計が24時間を超えています")
    end
  end

  def date_cannot_be_in_the_future
    if date.presence && date > Date.today
      errors.add(:date, "に未来の日付を設定することはできません")
    end
  end

  # simple_calendar
  def start_time
    date
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  class << self
    def today_study_time
      today_learnings = where(date: Date.today)
      learning_time_sum(today_learnings)
    end

    def yesterday_study_time
      yesterday_learnings = where(date: Date.yesterday)
      learning_time_sum(yesterday_learnings)
    end

    def week_study_time
      to = Time.current
      from = (to - 6.day).at_beginning_of_day
      week_learnings = where(date: from...to)
      learning_time_sum(week_learnings)
    end

    def month_study_time
      to = Time.current
      from = (1.month.ago + 1.day).at_beginning_of_day
      month_learnings = where(date: from...to)
      learning_time_sum(month_learnings)
    end

    def learning_time_sum(date_ranges)
      total_time = date_ranges.inject(0) { |sum, date_range| sum + date_range.time }
      total_time.floor(1)
    end

    def learnings_period(period)
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
        learnings = where(date: date)
        sum_times = learning_time_sum(learnings)
        dates.store(date.to_s, sum_times)
      end
      dates
    end
  end
end
