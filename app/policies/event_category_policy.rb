class EventCategoryPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    user.present? && record.event.organizers.include?( user )
  end

  def update?
    Rails.logger.debug( "\n\n\nEvent Organizers.first: " )
    Rails.logger.debug( record.event.organizers.first )
    Rails.logger.debug( "\n\n\nCurrent User: " )
    Rails.logger.debug( user.attributes )
    Rails.logger.debug( "\n\n\n" )
    user.present? && record.event.organizers.include?( user )
  end

  def destroy?
    user.present? && record.event.organizers.include?( user )
  end
end
