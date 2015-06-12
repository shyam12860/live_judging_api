ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.fail_fast                  = true
  config.formatter                  = 'documentation'
  config.include FactoryGirl::Syntax::Methods
  config.include JSONMacros
  config.include SerializerMacros

  # APIPIE
  config.filter_run :show_in_doc => true if ENV['APIPIE_RECORD']
end
