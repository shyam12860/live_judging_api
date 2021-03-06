# == Schema Information
#
# Table name: event_categories
#
#  id          :integer          not null, primary key
#  event_id    :integer          not null
#  label       :string           not null
#  color       :integer          not null
#  due_at      :datetime
#  description :string
#  rubric_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EventCategory < ActiveRecord::Base
  belongs_to :event
  has_many :team_categories, foreign_key: "category_id", dependent: :destroy
  has_many :teams, through: :team_categories
  belongs_to :rubric

  validates :event,
    presence: true

  validates :label,
    presence: true,
    uniqueness: { scope: :event }

  validates :color,
    presence: true,
    uniqueness: { scope: :event }
end
