FactoryBot.define do
  factory :user do
    username { "ABC" }
    email { "abc@abc.com" }
    password_digest { "password" }
  end
end
