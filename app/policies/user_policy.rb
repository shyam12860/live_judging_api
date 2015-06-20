class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

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
