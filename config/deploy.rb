require 'bundler/capistrano'

load 'deploy/assets'

set :application, 'eopas'
set :repository,  'git://github.com/eopas/eopas'
set :scm, :git

role :web, 'www.eopas.org'
role :app, 'www.eopas.org'
role :db,  'www.eopas.org', :primary => true # This is where Rails migrations will run

set :deploy_to, "/srv/www/#{application}"
set :user, 'deploy'
set :use_sudo, false
set :deploy_via, :remote_cache
set :keep_releases, 5

# database
namespace :deploy do
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
after 'deploy:update_code', 'deploy:symlink_shared'

# Unicorn
require 'capistrano-unicorn'
after 'deploy:restart', 'unicorn:restart'  # app preloaded

# Delayed job
require 'delayed/recipes'
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

namespace :delayed_job do
 desc "Stop the delayed_job process"
 task :stop, :roles => :app do
   run "cd #{current_path} && RAILS_ENV=production script/delayed_job stop"
 end
 desc "Start the delayed_job process"
 task :start, :roles => :app do
   run "cd #{current_path} && RAILS_ENV=production script/delayed_job start"
 end
 desc "Restart the delayed_job process"
 task :restart, :roles => :app do
   stop
   start
 end
end
