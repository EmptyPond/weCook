FactoryGirl.define do

  factory :user do
    email "awesome@email.com"
    password "password"
    password_confirmation "password"

    after(:create) do |user|
      user.kitchen << FactoryGirl.create(:kitchen)
    end
  end

  factory :recipe do
    name "best food ever"
    description "as the name implies"

    after(:create) do |recipe|
      recipe.kitchen << FactoryGirl.create(:kitchen)
    end
  end

  factory :kitchen do 
    association :user
    association :recipe
  end

  factory :ingredient do
    name "awesome"
    amount "alot"
    association :recipe
  end

  factory :step do
    step_num 1
    description "the only step you need for great food"
    association :recipe
  end
end
