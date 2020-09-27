FactoryBot.define do
  factory :post do
    user
    sequence(:title) { |n| "テスト#{n}" }
    author { "佐藤テスト" }
    genre { "not_select" }
    rating { "not_select" }
    hours { "not_select" }
  end

  factory :hibana, class: Post do
    title { "火花" }
    author { "又吉直樹" }
    publisher { "文春文庫" }
    genre { "novel" }
    rating { "int4" }
    hours { "to30" }
    purchase_date { "2020-7-15" }
    post_content { "面白い作品でした。" }
  end

  factory :jibun_nonakani_doku, class: Post do
    title { "自分の中に毒を持て" }
    author { "岡本太郎" }
    publisher { "青春文庫" }
    genre { "business" }
    rating { "int4_5" }
    hours { "to40" }
    purchase_date { "2019-12-20" }
    post_content { "とてもためになりました。" }
  end


end