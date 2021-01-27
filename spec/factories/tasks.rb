FactoryBot.define do
  factory :task do
    title { "ToDoリストのタイトル" }
    detail { "ToDoリストの詳細" }
    due { Time.now.next_day }
    association :user, factory: :user
  end

  factory :task_one, class: Task do
    title { "一番目のリストのタイトル" }
    detail { "一番目のリストの詳細" }
    due { Time.now.next_day }
    association :user, factory: :user
  end

  factory :task_second, class: Task do
    title { "二番目のリストのタイトル" }
    detail { "二番目のリストの詳細" }
    due { Time.now.next_day }
    association :user, factory: :user
  end
end
