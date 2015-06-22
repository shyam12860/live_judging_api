# == Schema Information
#
# Table name: judge_teams
#
#  id         :integer          not null, primary key
#  judge_id   :integer          not null
#  team_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class JudgeTeam < ActiveRecord::Base
  belongs_to :judge, class_name: "EventJudge", foreign_key: "judge_id"
  belongs_to :team,  class_name: "EventTeam",  foreign_key: "team_id"

  validates :team,
    presence: true,
    uniqueness: { scope: :judge }

  validates :judge,
    presence: true

  validate :events_must_match, if: "judge_id && team_id"

  private
    def events_must_match
      if team.event != judge.event
        errors.add( :team, "event does not match Judge event" )
      end
    end
end
