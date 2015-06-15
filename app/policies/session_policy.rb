class SessionPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    user.present?
  end
end
