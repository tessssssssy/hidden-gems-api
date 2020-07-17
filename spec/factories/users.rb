FactoryBot.define do
  factory :user do
    username { "Test User" }
    email { "test@gmail.com" }
    password_digest { "password" }
  end
end
