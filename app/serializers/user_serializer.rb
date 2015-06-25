# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :admin, :token

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
