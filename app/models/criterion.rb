# == Schema Information
#
# Table name: criteria
#
#  id         :integer          not null, primary key
#  label      :string           not null
#  min_score  :integer          default(0), not null
#  max_score  :integer          default(5), not null
#  rubric_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Criterion < ActiveRecord::Base
  belongs_to :rubric
  has_many :judgments, dependent: :destroy

  validates :label,
    presence: true,
    uniqueness: { scope: :rubric, case_sensitive: false }

  validates :rubric,
    presence: true

  validates :min_score, :max_score,
    presence: true

  validates :min_score,
    numericality: { greater_than_or_equal_to: 0, only_integer: true },
    if: :scores_defined?

  validates :max_score,
    numericality: { greater_than: :min_score, only_integer: true },
    if: :scores_defined?

  private
    def scores_defined?
      min_score && max_score
    end
end
