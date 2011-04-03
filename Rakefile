# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Eopas::Application.load_tasks


namespace :release do

  desc "Create a tar ball of the most recent tag"
  task :latest do
    version = `git tag | tail -1`.chomp
    sh "git archive --prefix=eopas-#{version}/ --format=tar #{version} | gzip > ../eopas-#{version}.tar.gz"
  end
end
