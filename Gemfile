# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'

gem 'rails', '3.0.0'

gem 'mysql'

gem 'haml'
gem 'compass'
#gem 'authlogic', :git => 'git://github.com/odorcicd/authlogic.git', :branch => 'rails3' 
#gem 'authlogic', :git => 'git://github.com/yalab/authlogic.git'
gem 'authlogic', :git => 'git://github.com/johnf/authlogic.git'
gem 'declarative_authorization'
gem 'paperclip'
gem 'delayed_paperclip'
gem 'delayed_job', '2.1.0.pre2'
gem 'nokogiri'
gem 'xml-object'
gem 'libxml-ruby'

#gem 'exception_notifier'

group :development, :test, :cucumber do
    gem 'sqlite3-ruby'
    gem 'capybara'
    gem 'rack-test', :git => 'git://github.com/johnf/rack-test.git' # Remove this line when http://github.com/brynary/rack-test/issues#issue/14
    gem 'database_cleaner'
    gem 'cucumber', :git => 'git://github.com/aslakhellesoy/cucumber.git'  # waiting on bugfix for http://github.com/aslakhellesoy/cucumber-rails/issues/issue/52
    gem 'cucumber-rails'

    gem 'rspec-rails', '>= 2.0.0.beta.20'

    gem 'spork'
    gem 'launchy'

    gem 'pickle'
    gem 'factory_girl'
end
