# == Schema Information
#
# Table name: platforms
#
#  id    :integer          not null, primary key
#  label :string           not null
#

class PlatformSerializer < ActiveModel::Serializer
  attributes :id, :label
end
