# == Schema Information
#
# Table name: tokens
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  expires_at   :datetime         default(Sat, 01 Aug 2015 02:09:33 UTC +00:00), not null
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :token do
    access_token { SecureRandom.hex }
    expires_at   { 2.weeks.from_now }
    user
  end
end
