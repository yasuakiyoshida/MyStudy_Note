class Batch::CounterCulture
  def self.learning_counter_fix
    LearningComment.counter_culture_fix_counts
    Favorite.counter_culture_fix_counts
    p "カウンターを修正しました"
  end
end
