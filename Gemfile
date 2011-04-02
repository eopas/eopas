# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'

gem 'rails', '3.0.5'

gem 'mysql2'

gem 'haml'
gem 'compass'
gem 'authlogic', :git => 'git://github.com/johnf/authlogic.git' # Removes deprecations
gem 'declarative_authorization'
gem 'paperclip'
gem 'delayed_paperclip'
gem 'delayed_job'
gem 'delayed_job_admin'
gem 'daemons', '1.0.10' # Need this otherwise delayed job won't start when talking to mysql https://github.com/collectiveidea/delayed_job/issues#issue/81
gem 'nokogiri'
gem 'will_paginate', '3.0.pre2'

group :development, :test, :cucumber do
    gem 'sqlite3-ruby'

    #gem 'cucumber-rails', :git => 'https://github.com/aslakhellesoy/cucumber-rails.git' # https://github.com/aslakhellesoy/cucumber-rails/issues/issue/77
    gem 'cucumber-rails' #, :git => 'git://github.com/johnf/cucumber-rails.git' # FIx capybara date steps plus issue 77 above

    gem 'capybara'
    gem 'database_cleaner'

    gem 'rspec-expectations', :git => 'https://github.com/rspec/rspec-expectations.git' # Remove this whole line when https://github.com/rspec/rspec-expectations/issues/63 is released
    gem 'rspec-rails'

    gem 'launchy'

    gem 'factory_girl'
    gem 'pickle'

    gem 'railroady'
end
