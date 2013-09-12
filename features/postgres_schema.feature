Feature: postgres schema
  In order to easily make sure the migrations work in target environment
  I want to run them on a Postgres database
  With an explicitly defined schema

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

          it "drops the table even when there are still records" do
            db[:users].insert id: 42
            migrate! :down
            db.table_exists?(:users).should be_false
          end
        end
      end
      """
    When I run `rspec spec`
    Then the examples should pass

  Scenario: different schemas in different contexts
    Given an empty database
    And a file named "spec/migrations/002_add_users_foo_spec.rb" with:
      """ruby
      require 'spec_helper'
      
      describe 'db/migrations/002_add_users_foo.rb' do
        describe "up" do
          postgres_schema do
            create_table :users do
              primary_key :id
            end
          end
      
          it "adds the foo column" do
            migrate! :up
            db[:users].columns.should include(:foo)
          end
        end

        describe "down" do
          postgres_schema do
            create_table :users do
              primary_key :id
              String :foo
            end
          end
      
          it "removes the foo column" do
            migrate! :down
            db[:users].columns.should_not include(:foo)
          end
        end
      end
      """
    When I run `rspec spec`
    Then the examples should pass

  