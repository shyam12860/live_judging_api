# == Schema Information
#
# Table name: team_categories
#
#  id          :integer          not null, primary key
#  team_id     :integer          not null
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class JudgeTeamSerializer < ActiveModel::Serializer
  attributes :id, :team, :judge
end
