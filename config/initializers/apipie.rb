Apipie.configure do |config|
  config.app_name                = "LiveJudging"
  config.api_base_url            = ""
  config.doc_base_url            = "/apipie"
  config.disqus_shortname        = "live-judge-api"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
