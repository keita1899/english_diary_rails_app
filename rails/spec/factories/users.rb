FactoryBot.define do
  factory :user do
    name { 'Example User' }
    sequence(:email) {|n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
