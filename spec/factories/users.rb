FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'aaaa' }
    password_confirmation { 'aaaa' }
  end
end
