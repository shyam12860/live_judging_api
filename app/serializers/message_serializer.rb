# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  subject      :string           not null
#  body         :string           not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#  read         :datetime
#

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :subject, :body

  belongs_to :sender
  belongs_to :recipient
end
