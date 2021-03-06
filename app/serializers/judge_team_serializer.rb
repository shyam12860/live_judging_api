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

class JudgeTeamSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :team
  belongs_to :judge
  has_one :event
end
