FactoryBot.define do
  factory :user do
    nickname { "ユーザー" }
    biography { "ユーザーです。よろしくお願いします。" }
    sequence(:email) { |n| "usertest#{n}@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
  end
  
  factory :alice, class: User do
    nickname { "Alice" }
    biography { "Aliceです。よろしくお願いします。" }
    sequence(:email) { |n| "alicetest#{n}@example.com" }
    password { "aaaaaa" }
    password_confirmation { "aaaaaa" }
  end
  
  factory :bob, class: User do
    nickname { "Bob" }
    biography { "Bobです。よろしくお願いします。" }
    sequence(:email) { |n| "bobtest#{n}@example.com" }
    password { "bbbbbb" }
    password_confirmation { "bbbbbb" }
  end
end
