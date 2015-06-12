FactoryGirl.define do
  factory :role do
    label { Faker::Name.first_name }
  end
end
