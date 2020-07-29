FactoryBot.define do
  factory :user do
    sequence(:nickname) { |n| "testuser#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end