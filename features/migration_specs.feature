Feature: migration specs
  In order to make sure migrations perform as intended
  The developer should be able to easily spec them
  
  Scenario: simple passing spec
    Given a file named "spec/migrations/001_create_users_spec.rb" with:
      """ruby
      require 'spec_helper'
      
      describe 'db/migrations/001_create_users.rb' do
        it "creates the users table" do
          expect(db.table_exists?(:users)).to be false
          migrate! :up
          expect(db.table_exists?(:users)).to be true
          migrate! :down
          expect(db.table_exists?(:users)).to be false
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
          expect(db.table_exists?(:users)).to be true
        end
        
        it "makes an id column in users table" do
          migrate! :up
          expect { db[:users].insert(id: 42) } .to_not raise_error
        end
      end
      """
    When I run `rspec spec`
    Then the example should pass
