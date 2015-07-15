class CriterionPolicy < ApplicationPolicy
  def index?
    user.present? && ( record.first.rubric.event.organizers.include?( user ) || record.first.rubric.event.judges.include( user ) )
  end

  def show?
    user.present? && ( record.rubric.event.organizers.include?( user ) || record.rubric.event.judges.include?( user ) )
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
