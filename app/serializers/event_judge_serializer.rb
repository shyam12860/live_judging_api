# == Schema Information
#
# Table name: event_judges
#
#  id       :integer          not null, primary key
#  event_id :integer          not null
#  judge_id :integer          not null
#

class EventJudgeSerializer < ActiveModel::Serializer
  attributes :event_id, :judge_id

  has_many :teams, embed: :ids
end
