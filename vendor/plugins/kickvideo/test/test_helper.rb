RAILS_ENV = ENV["RAILS_ENV"] = "test"
RAILS_ROOT = File.dirname(__FILE__) + '/rails'

# load the support libraries
require 'test/unit'
require 'rubygems'
require 'ruby-debug'
require 'mocha'

require 'shoulda'
require 'aws/s3'

gem 'rails', '2.3.5'
require 'active_support/test_case'
require 'active_record'
require 'action_mailer'

# establish the database connection
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/db/database.yml'))
ActiveRecord::Base.establish_connection('kickvideo_test')

# capture the logging
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/test.log")

# load the schema ... silently
ActiveRecord::Migration.verbose = false
load(File.dirname(__FILE__) + "/db/schema.rb")

# prepare for autoloading
PLUGIN_ROOT = File.join(File.dirname(__FILE__), '..')
ActiveSupport::Dependencies.load_paths << File.join(PLUGIN_ROOT, 'lib')
$LOAD_PATH.unshift File.join(PLUGIN_ROOT, 'lib')

ActionMailer::Base.delivery_method = :test

# load the code-to-be-tested
require File.dirname(__FILE__) + '/../init'

class Kickvideo::TestCase < ActiveSupport::TestCase
end
