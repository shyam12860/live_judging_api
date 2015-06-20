class Event < ActiveRecord::Base
  # Associations
  has_many :event_organizers
  has_many :organizers, through: :event_organizers

  # Validations
  validates :name,
    presence: true

  validates :location,
    presence: true

  validates :start_time,
    presence: true

  validates :end_time,
    presence: true
end
