module Public::LearningTimesHelper
  def sum_times(chart)
    chart.values.inject(:+).floor(1) unless chart.nil?
  end

  def to_minute(chart)
    hour = sum_times(chart) * 60.0
    hour.round(0)
  end
end
