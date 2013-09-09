module RSpec::Sequel
  module MigrationExampleGroup
    
    def self.included(base)
      base.class_eval do
        let(:db) { Sequel::connect 'sqlite:/' }
        let(:migration) { load_migration migration_path }
      end
    end
    
    def migrate! direction
      migration.apply db, direction
    end
    
    private
    def load_migration path
      Sequel.extension :migration
      require path
      Sequel::Migration.descendants.pop
    end

  end
end
