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

class JudgmentSerializer < ActiveModel::Serializer
  attributes :id, :value, :judge, :team, :criterion
end
