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

class TeamCategorySerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :team
  belongs_to :category
end
