# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'

gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql'

gem 'haml', :git => 'http://github.com/DohMoose/haml.git' # Use until the following issue is resolved http://github.com/nex3/haml/issues/issue/190
gem 'compass'
gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3'
gem 'declarative_authorization', :git => 'git://github.com/stffn/declarative_authorization.git'
gem 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git'
gem 'delayed_paperclip'
gem 'delayed_job', :git => 'git://github.com/collectiveidea/delayed_job.git'

#gem 'exception_notifier'

group :cucumber do
    gem 'sqlite3-ruby', '!= 1.3.0', :require => 'sqlite3'
    gem 'capybara'
    gem 'database_cleaner'
    gem 'cucumber-rails'

    gem 'rspec-rails', '2.0.0.beta.14.2'

    gem 'spork'
    gem 'launchy'

    gem 'pickle'
    gem 'factory_girl', :git => 'git://github.com/thoughtbot/factory_girl.git', :branch => 'fixes_for_rails3'
end
