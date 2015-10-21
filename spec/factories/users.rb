require 'faker'

FactoryGirl.define do
  factory :user do
    name         { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    slack_name   { Faker::Name.first_name }
    group_id     { Faker::Number.digit }
  end
end
