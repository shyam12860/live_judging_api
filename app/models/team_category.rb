class TeamCategory < ActiveRecord::Base
  belongs_to :team,     class_name: "EventTeam",     foreign_key: "team_id"
  belongs_to :category, class_name: "EventCategory", foreign_key: "category_id"

  validates :team,
    presence: true,
    uniqueness: { scope: :category }

  validates :category,
    presence: true

  validate :events_must_match, if: "team_id && category_id"

  private
    def events_must_match
      if team.event != category.event
        errors.add( :team, "event does not match category event" )
      end
    end
end
