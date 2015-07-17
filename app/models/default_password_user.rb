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
