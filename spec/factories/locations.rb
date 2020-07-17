FactoryBot.define do
  factory :location do
    name { "Test Location" }
    tagline { "A nice place"}
    description { "Awesome views!" }
    address { "Somewhere" }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end
