# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  location   :string           not null
#  start_time :datetime         not null
#  end_time   :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Event < ActiveRecord::Base
  before_create :set_up_default_category

  # Associations
  has_many :event_organizers, dependent: :destroy
  has_many :event_judges, dependent: :destroy

  has_many :organizers, through: :event_organizers
  has_many :judges, through: :event_judges
  has_many :categories, class_name: "EventCategory", dependent: :destroy
  has_many :teams, class_name: "EventTeam", dependent: :destroy
  has_many :rubrics, through: :categories
  has_many :criteria, through: :rubrics
  has_many :judgments, through: :criteria

  # Validations
  validates :name,
    presence: true

  validates :location,
    presence: true

  validates :start_time,
    presence: true

  validates :end_time,
    presence: true

  private
    def set_up_default_category
      self.categories << EventCategory.create( 
        event_id: id, 
        label: "Uncategorized",
        color: 12303291,
        description: "The default category for an event. All teams you create without explicit categories will be placed here."
      )
    end
end
