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

class EventOrganizer < ActiveRecord::Base
  belongs_to :event
  belongs_to :organizer, class_name: "User", foreign_key: "organizer_id"

  validates :event,
    presence: true

  validates :organizer,
    presence: true,
    uniqueness: { scope: :event }
end
