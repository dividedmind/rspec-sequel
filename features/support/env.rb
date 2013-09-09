require 'aruba/cucumber'

Before do
  step %q{a file named "spec/spec_helper.rb" with:}, %q{require 'rspec/sequel'}
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
