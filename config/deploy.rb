
require "bundler/capistrano"

set :application, "eopas"
set :repository,  "lp:eopas"

set :scm, :bzr

role :web, "eopas.rnld.unimelb.edu.au"
role :app, "eopas.rnld.unimelb.edu.au"
role :db,  "eopas.rnld.unimelb.edu.au", :primary => true # This is where Rails migrations will run

set :user, 'deploy'
set :use_sudo, false
set :deploy_to, "/srv/www/#{application}"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# Delayed job
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
