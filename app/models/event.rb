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
  has_many :event_organizers
  has_many :organizers, through: :event_organizers
  has_many :event_judges
  has_many :judges, through: :event_judges
  has_many :categories, class_name: "EventCategory"

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
      self.categories << EventCategory.create( event_id: id, label: "Uncategorized" )
    end
end
