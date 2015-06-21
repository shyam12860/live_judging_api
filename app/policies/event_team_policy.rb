class EventTeamPolicy < ApplicationPolicy
  def index?
    user.present?
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
