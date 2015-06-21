# == Schema Information
#
# Table name: event_judges
#
#  id       :integer          not null, primary key
#  event_id :integer          not null
#  judge_id :integer          not null
#

class EventJudge < ActiveRecord::Base
  belongs_to :event
  belongs_to :judge, class_name: "User", foreign_key: "judge_id"

  validates :event,
    presence: true,
    uniqueness: { scope: :judge }

  validates :judge,
    presence: true
end
