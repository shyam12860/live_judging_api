module Roles
  roles = [
    {
      label: "organizer"
    },
    {
      label: "judge"
    }
  ]

  roles.each do |role|
    Role.create!( role )
  end
end
