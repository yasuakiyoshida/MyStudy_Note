module LearningNewModule
  def learning_create(learning)
    fill_in "学習日", with: "2021-01-01"
    fill_in "学習時間", with: "10"
    fill_in "タイトル", with: "学習記録タイトル1"
    fill_in "詳細", with: "学習記録詳細1"
    fill_in "タグ", with: "rails,ruby"
    choose "公開する"
  end

  def learning_create_second(learning)
    fill_in "学習日", with: "2021-02-02"
    fill_in "学習時間", with: "20"
    fill_in "タイトル", with: "学習記録タイトル2"
    fill_in "詳細", with: "学習記録詳細2"
    fill_in "タグ", with: "django,python"
    choose "非公開"
  end
end
