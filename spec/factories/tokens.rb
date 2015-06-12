FactoryGirl.define do
  factory :token do
    access_token { SecureRandom.hex }
    expires_at   { 2.weeks.from_now }
    user
  end
end
