# == Schema Information
#
# Table name: platforms
#
#  id    :integer          not null, primary key
#  label :string           not null
#

class Platform < ActiveRecord::Base
  has_many :users

  validates :label,
    presence: true,
    uniqueness: { case_sensitive: false }
end
