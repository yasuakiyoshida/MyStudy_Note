class Learning < ApplicationRecord
  belongs_to :user
  has_many :learning_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  attachment :image
  
  # あとでリファクタリングする
  def self.today_study_time
    today_learnings = self.where(date: Date.today)
    total_time = 0
    today_learnings.each do |today_learning|
      total_time += today_learning.time
    end
    total_time.floor(1)
  end
  
  def self.yesterday_study_time
    today_learnings = self.where(date: Date.yesterday)
    total_time = 0
    today_learnings.each do |today_learning|
      total_time += today_learning.time
    end
    total_time.floor(1)
  end
end