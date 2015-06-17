class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :admin

  has_one :token

  def name
    object.name
  end
end
