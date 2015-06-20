FactoryGirl.define do
  factory :event do
    name       { Faker::App.name }
    location   { Faker::Address.street_address + ', ' + Faker::Address.city + ' ' + Faker::Address.state }
    start_time { Faker::Time.forward( 60, :morning )                          }
    end_time   { Faker::Time.between( start_time + 3.hours, start_time + 8.hours ) }
  end
end
