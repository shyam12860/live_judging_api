class EventPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present?
  end

  def show?
    user.present?
  end
end
