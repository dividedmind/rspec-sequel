require 'sequel'
require 'rspec/sequel'

module RSpec::Sequel::Test
  def self.postgres
    @pg_db ||= connect_to_postgres
  end
  
  private
  DEFAULT_TEST_DATABASE = 'postgres:///rspec-sequel-test'

  def self.connect_to_postgres
    test_database = ENV['TEST_DATABASE'] || begin
      STDERR.puts "TEST_DATABASE environment variable not found, defaulting to #{DEFAULT_TEST_DATABASE}"
      DEFAULT_TEST_DATABASE
    end

    Sequel::connect test_database
  end

end
