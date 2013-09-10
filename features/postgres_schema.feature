Feature: postgres schema
  In order to easily make sure the migrations work in target environment
  I want to run them on a Postgres database
  With an explicitly defined schema

  @wip
  Scenario: schema isolation
    Given an empty database
    And a file named "spec/migrations/001_create_users_spec.rb" with:
      """ruby
      require 'spec_helper'
      
      describe 'db/migrations/001_create_users.rb' do
        postgres_schema do
          create_table :users do
            primary_key :id
          end
        end
      
        describe "down" do
          it "drops the table" do
            db.table_exists?(:users).should be_true
            migrate! :down
            db.table_exists?(:users).should be_false
          end
        end
      end
      """
    When I run `rspec spec`
    Then the examples should pass
