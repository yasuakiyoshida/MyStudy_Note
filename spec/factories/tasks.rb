FactoryBot.define do
  factory :task do
    title { "ToDoリストのタイトル" }
    detail { "ToDoリストの詳細" }
    due { Time.now.next_day }
    association :user, factory: :user
  end 
end
