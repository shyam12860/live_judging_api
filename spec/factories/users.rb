# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  platform_id     :integer
#  gcm_token       :string
#  apn_token       :string
#

FactoryGirl.define do
  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.email( [ first_name, last_name ].join "_" ) }
    password              { Faker::Internet.password }
    password_confirmation { password }
    gcm_token             { SecureRandom.hex }
    apn_token             { SecureRandom.hex }
    platform
  end
end
