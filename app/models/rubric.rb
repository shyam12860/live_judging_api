class Rubric < ActiveRecord::Base
  # Associations
  belongs_to :event

  # Validations
  validates :name,
    presence: true

  validates :event,
    presence: true
end
