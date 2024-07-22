USER_COUNT = 10

USER_COUNT.times do |_i|
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'password123',
    password_confirmation: 'password123',
  )
end
