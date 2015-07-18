# == Schema Information
#
# Table name: rubrics
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Rubric < ActiveRecord::Base
  # Associations
  belongs_to :event
  has_many :categories, class_name: "EventCategory", dependent: :nullify
  has_many :criteria, dependent: :destroy

  # Validations
  validates :name,
    presence: true,
    uniqueness: { scope: :event }

  validates :event,
    presence: true
end
