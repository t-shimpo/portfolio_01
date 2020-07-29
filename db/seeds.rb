5.times do |n|
  User.create!(
    nickname: "test#{n + 1}",
    email: "test#{n+1}@example.com",
    password: "password",
    password_confirmation: "password",
    confirmed_at: Time.now
  )
end