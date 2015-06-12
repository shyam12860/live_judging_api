FactoryGirl.define do
  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email( [ first_name, last_name ].join "_" ) }
    password              { Faker::Internet.password }
    password_confirmation { password }
    role { Role.find_or_create_by attributes_for( :role, label: "organizer" ) }

    factory :admin_user do
      role { Role.find_or_create_by attributes_for( :role, label: "admin" ) }
    end

    factory :organizer_user do
      role { Role.find_or_create_by attributes_for( :role, label: "organizer" ) }
    end

    factory :judge_user do
      role { Role.find_or_create_by attributes_for( :role, label: "judge" ) }
    end
  end
end
