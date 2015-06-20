class EventOrganizer < ActiveRecord::Base
  belongs_to :event
  belongs_to :organizer, class_name: "User", foreign_key: "organizer_id"

  validates :event,
    presence: true

  validates :organizer,
    presence: true,
    uniqueness: { scope: :event }
end
