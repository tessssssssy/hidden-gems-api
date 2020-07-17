FactoryBot.define do
  factory :comment do
    body { "MyString" }
    user { nil }
    location { nil }
    comment { nil }
  end
end
