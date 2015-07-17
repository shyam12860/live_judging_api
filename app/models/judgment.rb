# == Schema Information
#
# Table name: judgments
#
#  id           :integer          not null, primary key
#  value        :integer          not null
#  team_id      :integer          not null
#  judge_id     :integer          not null
#  criterion_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Judgment < ActiveRecord::Base
  belongs_to :criterion
  belongs_to :judge, class_name: "EventJudge", foreign_key: "judge_id"
  belongs_to :team, class_name: "EventTeam", foreign_key: "team_id"
  has_one :rubric, through: :criterion
  has_one :event, through: :team

  validates :criterion,
    presence: true,
    uniqueness: { scope: [:team, :judge] }

  validates :judge,
    presence: true

  validates :team,
    presence: true

  validates :value,
    presence: true
  
  validates :value,
    numericality: { greater_than_or_equal_to: :criterion_min_score, less_than_or_equal_to: :criterion_max_score, only_integer: true },
    if: :value_set?

  validate :events_must_match,
    if: "judge_id && team_id && criterion_id" 

  private
    def value_set?
      value && criterion
    end

    def criterion_min_score
      criterion.min_score
    end

    def criterion_max_score
      criterion.max_score
    end

    def events_must_match
      if team.event != judge.event || team.event != criterion.rubric.event || judge.event != criterion.rubric.event
        errors.add( :criterion, "event does not match Team or Judge events" )
      end
    end
end
