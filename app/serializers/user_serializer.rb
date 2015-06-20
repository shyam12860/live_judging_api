class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :admin

  has_one :token

  def name
    object.name
  end

  def filter( keys )
    if scope.nil? || scope.id == object.id
      keys
    else
      keys - [:token]
    end
  end
end
