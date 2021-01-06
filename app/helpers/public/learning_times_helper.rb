module Public::LearningTimesHelper
  def sum_times
    @chart.values.inject(:+) unless @chart.nil?
  end

  def to_hour
    hour = sum_times / 60.0
    hour.round(2)
  end
end