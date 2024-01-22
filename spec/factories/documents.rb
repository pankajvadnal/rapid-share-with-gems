FactoryBot.define do
  factory :document do
    name { Faker::Lorem.word }
    file { Rack::Test::UploadedFile.new('spec/support/files/example.pdf', 'application/pdf') }
    upload_date { Faker::Date.backward(days: 10) }
    user
  end
end
