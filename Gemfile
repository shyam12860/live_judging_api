source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'rails-api'
gem 'spring', :group => :development
gem 'sqlite3'
gem 'bcrypt'

# Utility
gem 'apipie-rails', github: 'Apipie/apipie-rails', branch: 'master'
gem 'active_model_serializers', '~> 0.9.3' # JSON Serializer
gem 'email_validator',          '~> 1.6.0' # Helper for validating email fields
gem 'pundit',                   '~> 1.0.1' # Permissions

# Deployment
gem 'capistrano',               '~> 3.4.0'    # Deployment
gem 'capistrano-rails',         '~> 1.1.2'    # Deployment Helper
gem 'capistrano-bundler',       '~> 1.1.3'    # Deployment Helper
gem 'capistrano-rvm',           '~> 0.1.2'    # Deployment Helper

group :development, :test do
  gem 'rspec-rails',        '~> 3.2.3' # Testing framework
  gem 'faker',              '~> 1.4.3' # Stub out test data
  gem 'database_cleaner',   '~> 1.4.1' # Reset database after tests
  gem 'factory_girl_rails', '~> 4.5.0' # Create test models
  gem 'guard'                          # Automate tasks
  gem 'guard-livereload'               # Reload browser window automatically
  gem 'guard-rails'                    # Restart server when necessary
end
