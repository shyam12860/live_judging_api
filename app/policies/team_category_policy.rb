class TeamCategoryPolicy < ApplicationPolicy
  def index?
    user.present? && record.first.team.event.organizers.include?( user )
  end

  def create?
    user.present? && record.team.event.organizers.include?( user )
  end

  def destroy?
    user.present? && record.team.event.organizers.include?( user )
  end
end
