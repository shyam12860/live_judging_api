class CriterionPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present? && record.rubric.event.organizers.include?( user )
  end

  def update?
    user.present? && record.rubric.event.organizers.include?( user )
  end

  def destroy?
    user.present? && record.rubric.event.organizers.include?( user )
  end
end
