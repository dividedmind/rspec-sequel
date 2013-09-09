module RSpec::Sequel
  module MigrationExampleGroup
    
    def self.included(base)
      base.class_eval do
        let(:db) { Sequel::connect 'sqlite:/' }
      end
    end
    
    def migrate! direction
      migration.apply db, direction
    end

  end
end
