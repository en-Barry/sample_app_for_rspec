FactoryBot.define do
  factory :task do
    sequence(:title, "title01")
    content { "content01" }
    status { 0 }
    deadline { 1.week.from_now }
    association :user
  end
end
