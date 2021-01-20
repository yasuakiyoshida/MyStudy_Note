module Public::TasksHelper
  def add_class_name_progress(progress_status)
    if progress_status == '未着手'
      progress_status.gsub(progress_status, "new-task")
    elsif progress_status == '処理中'
      progress_status.gsub(progress_status, "processing-task")
    elsif progress_status == '完了済'
      progress_status.gsub(progress_status, "completed-task")
    elsif progress_status == '保留中'
      progress_status.gsub(progress_status, "pending-task")
    end
  end

  def add_class_name_priority_bg_color(priority_status)
    if priority_status == '高'
      priority_status.gsub(priority_status, "high-priority")
    elsif priority_status == '中'
      priority_status.gsub(priority_status, "medium-priority")
    elsif priority_status == '低'
      priority_status.gsub(priority_status, "low-priority")
    end
  end

  def add_class_name_priority_text_color(priority_status)
    if priority_status == '高'
      priority_status.gsub(priority_status, "text-danger")
    elsif priority_status == '中'
      priority_status.gsub(priority_status, "text-warning")
    elsif priority_status == '低'
      priority_status.gsub(priority_status, "text-dark")
    end
  end
end
