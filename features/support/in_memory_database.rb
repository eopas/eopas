

# When using selenium the separate process won't be able to access our in memory DB so we use a file based database
Before('@javascript') do
  ActiveRecord::Base.establish_connection ActiveRecord::Base.configurations['test']
end

After('@javascript') do
  # Defined in config/initializers/memory_test_database.rb
  setup_in_memory_database
end


