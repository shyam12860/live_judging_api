# == Schema Information
#
# Table name: event_categories
#
#  id         :integer          not null, primary key
#  event_id   :integer          not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventCategory < ActiveRecord::Base
  belongs_to :event

  validates :event,
    presence: true

  validates :label,
    presence: true,
    uniqueness: { scope: :event }
end
