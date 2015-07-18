# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  platform_id     :integer
#  gcm_token       :string
#  apn_token       :string
#

class DefaultPasswordUser < User
  def initialize(options = {})
    random_password = SecureRandom.urlsafe_base64(8)
    options[:password] = random_password
    options[:password_confirmation] = random_password
    options[:generated_password] = true

    # Call User.new(options)
    super(options)
  end
end
