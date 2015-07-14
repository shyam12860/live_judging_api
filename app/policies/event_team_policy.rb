class EventTeamPolicy < ApplicationPolicy
  def index?
    user.present? && ( record.first.event.organizers.include?( user ) || record.first.event.judges.include?( user ) )
  end

  def show?
    user.present? && ( record.event.organizers.include?( user ) || record.event.judges.include?( user ) )
  end

  def create?
    user.present? && record.event.organizers.include?( user )
  end

  def update?
    user.present? && record.event.organizers.include?( user )
  end

  def destroy?
    user.present? && record.event.organizers.include?( user )
  end
end
