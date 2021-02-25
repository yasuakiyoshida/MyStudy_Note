module LearningNewModule
  def learning_create(learning)
    fill_in "学習日", with: "2021-01-01"
    fill_in "学習時間", with: learning.time
    fill_in "タイトル", with: learning.title
    fill_in "詳細", with: learning.detail
    fill_in "タグ", with: "rails,ruby"
    choose "公開する"
  end
end
