FactoryBot.define do
  factory :task do
    title { 'sample01' }
    status { 0 } 
    association :user
  end
end
