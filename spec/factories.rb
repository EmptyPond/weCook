FactoryGirl.define do
  factory :user do
    email "awesome@email.com"
    password "password"
    password_confirmation "password"
  end
end
