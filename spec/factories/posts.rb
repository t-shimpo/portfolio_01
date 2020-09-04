FactoryBot.define do
  factory :post do
    user
    title { |n| "テスト#{n}" }
    author { "佐藤テスト" }
    genre { "not_select" }
    rating { "not_select" }
    hours { "not_select" }
  end

end