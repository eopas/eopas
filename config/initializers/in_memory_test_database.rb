def in_memory_database?
  ENV["RAILS_ENV"] == "test" and
  ActiveRecord::Base.configurations['test_in_memory']
end

def setup_in_memory_database
  ActiveRecord::Base.establish_connection ActiveRecord::Base.configurations['test_in_memory']
  ActiveRecord::Migration.suppress_messages do
    load "#{Rails.root}/db/schema.rb"
  end
end

if in_memory_database?
  puts "Preparing the in-memory database..."
  setup_in_memory_database
end
