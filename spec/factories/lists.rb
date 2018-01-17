FactoryBot.define do
  factory :list do
    association :user
    name "MyList"
  end
end
