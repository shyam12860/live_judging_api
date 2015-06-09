set :stage, :production
server 'api.stevedolan.me', user: 'deploy', roles: %w{web app}
