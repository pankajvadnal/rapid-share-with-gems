FactoryBot.define do
  factory :user do
    username { 'username' }
    name { 'fname lname' }
    email { 'user@example.com' }
    password { 'password' }
  end
end
