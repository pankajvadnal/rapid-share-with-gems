FactoryBot.define do
  factory :user do
    username { Faker::Internet.username(specifier: 8..30) }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password123' }

  end

end
