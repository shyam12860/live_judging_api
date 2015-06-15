class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    [:name, :location, :start_time, :end_time]
  end

  def index?
    user.present?
  end

  def create?
    user.present? && user.organizer?
  end

  def update?
    user.present? && user.organizer?
  end

  def show?
    user.present?
  end
end
