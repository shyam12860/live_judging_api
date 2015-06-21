# == Schema Information
#
# Table name: event_teams
#
#  id         :integer          not null, primary key
#  logo_id    :string
#  name       :string           not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :event_team do
    logo_id { fixture_file_upload( Rails.root.join( 'spec', 'files', 'team_logo.png' ), 'image/png' ) }
    name { Faker::Company.name }
    event
  end
end
