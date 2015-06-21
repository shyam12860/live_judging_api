class EventOrganizerPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def index_by_organizer?
    user.present?
  end

  def create?
    user.present? && record.event.organizers.include?( user )
  end

  def destroy?
    user.present? && record.event.organizers.include?( user )
  end
end
