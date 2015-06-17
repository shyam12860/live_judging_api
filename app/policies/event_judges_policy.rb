class EventJudgePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    user.present? && user.organizer?
  end

  def create?
    user.present? && record.event.organizer == user
  end

  def destroy?
    user.present? && record.event.organizer == user
  end
end
