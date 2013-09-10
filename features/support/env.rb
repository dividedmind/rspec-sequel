require 'aruba/cucumber'
require_relative 'postgres'

Before do
  step %q{a file named "spec/spec_helper.rb" with:}, %Q{
    require 'rspec/sequel'
    Sequel::connect '#{RSpec::Sequel::Test::postgres.uri}'
  }
  step %q{a file named "db/migrations/001_create_users.rb" with:}, %q{
    Sequel.migration do
      up do
        create_table :users do
          primary_key :id
        end
      end
      down do
        drop_table :users
      end
    end
  }
end
