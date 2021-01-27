FactoryBot.define do
  factory :learning do
    title { "学習記録のタイトル" }
    detail { "学習記録の詳細" }
    date { Date.today }
    time { "1.5" }
    association :user, factory: :user
  end
  
  factory :learning_english, class: Learning do
    title { "英語" }
    detail { "英語の勉強" }
    date { Date.today }
    time { "2.0" }
    association :user, factory: :user
  end
  
  factory :learning_math, class: Learning do
    title { "数学" }
    detail { "数学の勉強" }
    date { Date.today }
    time { "3.5" }
    association :user, factory: :user
  end
end
