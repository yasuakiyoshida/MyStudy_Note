# public/homeは全てのユーザーが閲覧できる
crumb :root do
  link "トップページ", root_path
end

crumb :common_learnings do
  link "みんなの学習記録", common_learnings_path
  parent :root
end

crumb :search_common_learnings do
  link "みんなの学習記録検索結果", search_common_learnings_path
  parent :common_learnings
end

# 新規登録
crumb :new_registration do
  link "会員登録", new_user_registration_path
  parent :root
end

# ログイン
crumb :new_session do
  link "ログイン", new_user_session_path
  parent :root
end

# パスワード再設定（パスワード変更画面には設定しない）
crumb :new_password do
  link "パスワード再設定", new_user_password_path
  parent :new_session
end

# public/userはログイン前はユーザー情報詳細のみ閲覧可、ログイン後は全てのページを閲覧可能だが情報編集は自分の情報のみ
crumb :users do |user|
  link "ユーザー一覧", users_path
  parent :root
end

crumb :search_users do |user|
  link "ユーザー検索結果", search_users_path
  parent :users
end

crumb :user do |user|
  link user.nickname + "さんの情報詳細", user_path(user)
  parent :users
end

crumb :edit_user do |user|
  link user.nickname + "さんの情報編集", edit_user_path(user)
  parent :user, user
end

# public/relationshipはログイン後のみ閲覧可能
crumb :followers_user do |user|
  link user.nickname + "さんのフォロワー", user_followers_path(user)
  parent :user, user
end

crumb :followings_user do |user|
  link user.nickname + "さんがフォロー中のユーザー", user_followings_path(user)
  parent :user, user
end

# public/learningはログイン前は学習記録詳細のみ閲覧可、ログイン後は全てのページを閲覧可能だが記録編集は自分の情報のみ
crumb :learnings do |learning|
  link "#{current_user.nickname}さんの学習記録一覧", learnings_path
  parent :root
end

crumb :search_learnings do |learning|
  link "#{current_user.nickname}さんの学習記録検索結果", search_learnings_path
  parent :learnings
end

crumb :new_learning do |learning|
  link "学習内容を記録する", new_learning_path
  parent :root
end

crumb :learning do |learning|
  link "#{learning.title}の詳細", learning_path(learning)
  if learning.user == current_user
    parent :learnings
  else
    parent :common_learnings
  end
end

crumb :edit_learning do |learning|
  link "#{learning.title}の編集", edit_learning_path(learning)
  parent :learning, learning
end

# public/leaning_timeはログインユーザーのみ閲覧可能
crumb :leaning_times do |leaning_times_user|
  link leaning_times_user.nickname + "さんの過去の学習時間", user_learning_times_path(leaning_times_user)
  parent :user, leaning_times_user
end

# public/taskはログインユーザーが自分の情報のみ閲覧可能
crumb :tasks do |task|
  link "ToDoリスト一覧", tasks_path
  parent :root
end

crumb :search_tasks do |task|
  link "ToDoリスト検索結果", search_tasks_path
  parent :tasks
end

crumb :new_task do |task|
  link "ToDoリストを作成する", new_task_path
  parent :root
end

crumb :task do |task|
  link "#{task.title}の詳細", task_path(task)
  parent :tasks
end

crumb :edit_task do |task|
  link "#{task.title}の編集", edit_task_path(task)
  parent :task, task
end
