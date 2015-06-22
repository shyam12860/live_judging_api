class TeamCategory < ActiveRecord::Base
  belongs_to :team,     class_name: "EventTeam",     foreign_key: "team_id"
  belongs_to :category, class_name: "EventCategory", foreign_key: "category_id"

  validate :events_must_match

  validates :team,
    presence: true,
    uniqueness: { scope: :category }

  validates :category,
    presence: true

  private
    def events_must_match
      if team.nil? || category.nil? || ( team.event != category.event )
        errors.add( :team, "event does not match category event" )
      end
    end
end
