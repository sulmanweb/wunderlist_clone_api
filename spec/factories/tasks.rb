FactoryBot.define do
  factory :task do
    association :list
    name "MyString"
    status "todo"
  end
end
