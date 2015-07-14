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

class Message < ActiveRecord::Base
  belongs_to :sender,    class_name: "User", dependent: :destroy
  belongs_to :recipient, class_name: "User", dependent: :destroy

  validates :subject,
    presence: true

  validates :body,
    presence: true

  validates :sender,
    presence: true

  validates :recipient,
    presence: true
end
