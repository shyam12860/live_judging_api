class UserPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    true
  end

  def update?
    user.present?
  end

  def show?
    user.present?
  end
end
