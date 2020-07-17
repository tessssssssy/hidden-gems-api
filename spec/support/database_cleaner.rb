RSpec.configure do |config|
    # Clear the entire database is cleared before running any tests
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end
  
    # The default recommended strategy to use
    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end
  
    # These two settings tell DatabaseCleaner to hook into the start and end of the tests.
    config.before(:each) do
      DatabaseCleaner.start
    end
  
    config.after(:each) do
      DatabaseCleaner.clean
    end
end

