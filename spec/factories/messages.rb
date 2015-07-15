# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  subject      :string           not null
#  body         :string           not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#  read         :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :message do
    subject { Faker::Lorem.word }
    body { Faker::Lorem.sentence }
    read { Faker::Time.between( 2.days.ago, Time.now, :day ) }
    association :sender, factory: :user
    association :recipient, factory: :user
  end
end
