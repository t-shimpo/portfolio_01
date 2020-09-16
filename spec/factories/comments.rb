FactoryBot.define do
  factory :comment do
    user
    post
    comment_content { "私も読みました。面白かったです。" }
  end

end