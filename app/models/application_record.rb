class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def created_at_jst
    created_at.in_time_zone('Tokyo').strftime("%Y年%m月%d日 %H:%M")
  end
end
