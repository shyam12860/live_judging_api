# == Schema Information
#
# Table name: event_judges
#
#  id       :integer          not null, primary key
#  event_id :integer          not null
#  judge_id :integer          not null
#

class EventJudgeSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :event
  belongs_to :judge
end
