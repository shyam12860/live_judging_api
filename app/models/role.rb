class Role < ActiveRecord::Base
  has_many :users

  validates :label,
    presence: true
end
