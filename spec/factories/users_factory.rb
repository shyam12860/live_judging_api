FactoryGirl.define do
  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email( first_name + "_" + last_name ) }
    password              { Faker::Internet.password }
    password_confirmation { password }
  end
end
