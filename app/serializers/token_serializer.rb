# == Schema Information
#
# Table name: tokens
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  expires_at   :datetime         default(Sat, 04 Jul 2015 04:00:14 UTC +00:00), not null
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class TokenSerializer < ActiveModel::Serializer
  attributes :access_token
end
