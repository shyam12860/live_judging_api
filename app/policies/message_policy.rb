class MessagePolicy < ApplicationPolicy
  def index?
    user.present? && ( record.first.sender == user || record.first.recipient == user )
  end

  def create?
    user.present? && record.sender == user
  end
end
