FactoryBot.define do
  factory :learning_comment do
    comment { "コメントです。" }
    association :user, factory: :user
    association :learning, factory: :learning
  end
end
