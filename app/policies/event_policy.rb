class EventPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    user.present? && record.organizers.include?( user )
  end

  def show?
    user.present? && record.organizers.include?( user )
  end
end
