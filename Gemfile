# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'

gem 'rails', '3.0.0.beta3'

gem 'sqlite3-ruby', :require => 'sqlite3'

gem 'haml'
#gem 'exception_notifier'

group :cucumber do
    gem 'capybara', :git => "git://github.com/jnicklas/capybara.git"
    gem 'database_cleaner', :git => "git://github.com/bmabey/database_cleaner.git"
    gem 'cucumber-rails', :git => "git://github.com/aslakhellesoy/cucumber-rails.git"

    gem 'test-unit' # Bug in cucumber-rails at the moment which means we need to drag this in
    gem 'rspec-rails', :git => "git://github.com/rspec/rspec-rails.git"

    gem 'spork'
    gem 'launchy'

#    gem 'pickle'
#    gem 'factory_girl'
end
