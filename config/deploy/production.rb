set :stage, :production
server 'judging_api.stevedolan.me', user: 'deploy', roles: %w{web app}
