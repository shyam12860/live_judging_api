# == Schema Information
#
# Table name: platforms
#
#  id    :integer          not null, primary key
#  label :string           not null
#

FactoryGirl.define do
  factory :platform do
    label { Faker::Company.name }
  end
end
