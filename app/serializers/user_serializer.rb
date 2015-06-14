class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :admin, :role

  has_one :token

  def name
    object.name
  end

  def role
    object.role.label
  end
end
