
require "bundler/capistrano"

set :application, "eopas"
set :repository,  "git://github.com/eopas/eopas.git"

set :scm, :git

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