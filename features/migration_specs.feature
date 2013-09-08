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
          migrate!
          db.table_exists?(:users).should be_true
        end
      end
      """
    When I run `rspec spec`
    Then the example should pass
