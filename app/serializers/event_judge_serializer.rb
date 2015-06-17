class UserSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :judge_id
end
