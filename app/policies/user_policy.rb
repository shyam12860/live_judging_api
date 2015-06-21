class UserPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    true
  end

  def update?
    user.admin? || user == record
  end

  def show?
    user.present?
  end
end
