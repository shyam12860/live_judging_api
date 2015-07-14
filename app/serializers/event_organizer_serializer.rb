# == Schema Information
#
# Table name: event_organizers
#
#  id           :integer          not null, primary key
#  event_id     :integer          not null
#  organizer_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class EventOrganizerSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :event
  belongs_to :organizer
end
