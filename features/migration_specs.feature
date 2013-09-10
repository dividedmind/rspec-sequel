Feature: migration specs
  In order to make sure migrations perform as intended
  The developer should be able to easily spec them
  
  Scenario: simple passing spec
    Given a file named "spec/migrations/001_create_users_spec.rb" with:
      """ruby
      require 'spec_helper'
      
      describe 'db/migrations/001_create_users.rb' do
        it "creates the users table" do
          db.table_exists?(:users).should be_false
          migrate! :up
          db.table_exists?(:users).should be_true
          migrate! :down
          db.table_exists?(:users).should be_false
        end
      end
      """
    When I run `rspec spec`
    Then the example should pass

  Scenario: several examples
    Given a file named "spec/migrations/001_create_users_spec.rb" with:
      """ruby
      require 'spec_helper'
      
      describe 'db/migrations/001_create_users.rb' do
        it "creates the users table" do
          migrate! :up
          db.table_exists?(:users).should be_true
        end
        
        it "makes an id column in users table" do
          migrate! :up
          expect { db[:users].insert(id: 42) } .to_not raise_error
        end
      end
      """
    When I run `rspec spec`
    Then the example should pass
