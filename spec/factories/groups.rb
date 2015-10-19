require 'faker'
require 'factory_girl_rails'
FactoryGirl.define do
  factory :group do
    group_name  { Faker::Company.name }
  end
end
