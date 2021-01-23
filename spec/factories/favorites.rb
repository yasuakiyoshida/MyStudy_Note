FactoryBot.define do
  factory :favorite do
    association :user, factory: :user
    association :learning, factory: :learning
  end 
end
