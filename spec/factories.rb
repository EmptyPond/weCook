FactoryGirl.define do

  factory :user do
    sequence :email do |n|
      "awesomeemail#{n}@email.com"
    end
    password "password"
    password_confirmation "password"
  end

  factory :kitchen do 
    name "awesome kitchen"
    after(:create) {|kitchen| kitchen.user = [create(:user)]}
    association :recipe
  end

  factory :recipe do
    name "best food ever"
    description "as the name implies"
  end

  factory :ingredient do
    name "awesome"
    amount "alot"
    association :kitchen
  end

  factory :step do
    step_num 1
    description "the only step you need for great food"
    association :kitchen
  end
end
