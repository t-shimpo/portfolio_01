FactoryBot.define do
  factory :user do
    nickname { "testuser"}
    email { |n| "testuser#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :kenji, class: User do
    nickname { "けんじ" }
    email { "kenji@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :michael, class: User do
    nickname { "michael" }
    email { "michael@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end