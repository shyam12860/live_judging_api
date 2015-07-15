module Platforms
  platforms = [
    {
      label: "iOS"
    },
    {
      label: "Android"
    },
    {
      label: "Web"
    }
  ]

  platforms.each do |platform|
    Platform.create!( platform )
  end
end

