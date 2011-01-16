# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'

gem 'rails', '3.0.3'

gem 'mysql'

gem 'haml'
gem 'compass'
gem 'authlogic', :git => 'git://github.com/johnf/authlogic.git' # Removes deprecations
gem 'declarative_authorization'
gem 'paperclip'
gem 'delayed_paperclip'
gem 'delayed_job', '2.1.0.pre2'
gem 'nokogiri'
gem 'xml-object'
gem 'libxml-ruby'
gem 'will_paginate', '3.0.pre2'

#gem 'sunspot_rails'

#gem 'exception_notifier'

group :development, :test, :cucumber do
    gem 'sqlite3-ruby'

    #gem 'cucumber-rails', :git => 'https://github.com/aslakhellesoy/cucumber-rails.git' # https://github.com/aslakhellesoy/cucumber-rails/issues/issue/77
    gem 'cucumber-rails', :git => 'git://github.com/johnf/cucumber-rails.git' # FIx capybara date steps plus issue 77 above

    gem 'capybara'
    gem 'database_cleaner'

    gem 'rspec-rails'

    gem 'spork'
    gem 'launchy'

    gem 'pickle'
    gem 'factory_girl'

    gem 'hirb'

#    gem 'zombie', :git => 'git://github.com/assaf/zombie.git'
#    gem 'capybara-zombie', :git => 'git://github.com/plataformatec/capybara-zombie.git'
end
