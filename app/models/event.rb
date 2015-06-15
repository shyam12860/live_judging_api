class Event < ActiveRecord::Base
  belongs_to :organizer, class_name: "User", foreign_key: "organizer_id"
  
  validates :name,
    presence: true

  validates :location,
    presence: true

  validates :start_time,
    presence: true

  validates :end_time,
    presence: true
end
