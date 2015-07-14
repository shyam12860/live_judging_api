class UserPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    true
  end

  def update?
    user.admin? || user == record || ( record.judged_events.include?( user.organized_events ) && record.created_at > 30.minutes.ago )
  end

  def show?
    user.present?
  end

  def permitted_attributes
    if user.admin? || user == record
      [:first_name, :last_name, :email, :password, :password_confirmation]
    else
      [:first_name, :last_name]
    end
  end
end
