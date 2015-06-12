module Roles
  roles = [
    {
      label: "admin"
    },
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
