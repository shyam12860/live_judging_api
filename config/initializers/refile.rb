# require "refile/s3"

# aws = {
#   access_key_id: Rails.application.secrets[:aws][:access_key],
#   secret_access_key: Rails.application.secrets[:aws][:secret],
#   region: "us-east-1",
#   bucket: "live-judging"
# }

# Refile.cache = Refile::S3.new(max_size: 1.megabyte, prefix: "cache", **aws)
# Refile.store = Refile::S3.new(max_size: 1.megabyte, prefix: "store", **aws)
