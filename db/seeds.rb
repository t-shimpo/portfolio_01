100.times do |n|
  nickname = Faker::Name.first_name
  email = "example#{n+1}@example.com"
  User.create!(
    nickname: nickname,
    email: email,
    password: "password",
    password_confirmation: "password",
    confirmed_at: Time.now
  )
end