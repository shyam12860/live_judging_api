# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  location   :string           not null
#  start_time :datetime         not null
#  end_time   :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  map_id     :string
#

FactoryGirl.define do
  factory :event do
    name       { Faker::App.name }
    location   { Faker::Address.street_address + ', ' + Faker::Address.city + ' ' + Faker::Address.state }
    start_time { Faker::Time.forward( 60, :morning )                          }
    end_time   { Faker::Time.between( start_time + 3.hours, start_time + 8.hours ) }
  end
end
