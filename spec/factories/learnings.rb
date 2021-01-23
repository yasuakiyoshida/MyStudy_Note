FactoryBot.define do
  factory :learning do
    title { '学習記録のタイトル' }
    detail { '学習記録の詳細' }
    date { Date.today }
    time { '1.5' }
    association :user, factory: :user
  end 
end
