Apipie.configure do |config|
  config.app_name                = "LiveJudging"
  config.api_base_url            = ""
  config.doc_base_url            = "/api"
  #config.disqus_shortname        = "live-judge-api"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.validate = false
  config.app_info = "An easy way to administer and monitor events with judges."
end
