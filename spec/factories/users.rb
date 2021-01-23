FactoryBot.define do
  factory :user do
    sequence(:nickname) { |n| "ユーザー #{n}" }
    biography { 'ユーザーです。よろしくお願いします。' }
    sequence(:email) { |n| "usertest#{n}@example.com" }
    password { '123456' }
    password_confirmation { '123456' }
  end 
end
