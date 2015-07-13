class JudgmentPolicy < ApplicationPolicy
  def index?
    user.present? && 
    ( record.criterion.rubric.event.organizers.include?( user ) || 
      record.criterion.rubric.event.judges.include?( user ) )
  end

  def show?
    user.present? && 
    ( record.criterion.rubric.event.organizers.include?( user ) || 
      record.criterion.rubric.event.judges.include?( user ) )
  end

  def create?
    user.present? && 
    ( record.criterion.rubric.event.organizers.include?( user ) || 
      record.criterion.rubric.event.judges.include?( user ) )
  end

  def update?
    user.present? && 
    ( record.criterion.rubric.event.organizers.include?( user ) || 
      record.criterion.rubric.event.judges.include?( user ) )
  end
end
