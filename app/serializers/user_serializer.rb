class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name

  has_one :token

  def name
    object.name
  end
end
