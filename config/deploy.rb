# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'live_judging_api'
set :repo_url, 'git@github.com:stephendolan/live_judging_api.git'
set :deploy_to, '/home/deploy/live_judging_api'

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing,  'deploy:cleanup'
end
