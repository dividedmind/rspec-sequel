module RSpec::Sequel
  module MigrationExampleGroup
    
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        let(:db) { Sequel::connect 'sqlite:/' }
        let(:migration) { load_migration migration_path }
        migration_example_group = self
        basedir = if defined? Rails then Rails.root else Dir.pwd end
        let(:migration_path) { File.expand_path(migration_example_group.description, basedir) }
      end
    end
    
    def migrate! direction
      migration.apply db, direction
    end
    
    module ClassMethods
      def postgres_schema &block
        db = Sequel::DATABASES.find { |db| db.database_type == :postgres }
        raise "Please connect to a Postgres database (eg. in spec_helper) before using ::postgres_schema." unless db
        db = Sequel.connect(db.opts.merge search_path: ['spec']).tap do |db|
          db.drop_schema :spec, cascade: true, if_exists: true
          db.create_schema :spec
          db.instance_eval &block if block
        end
        let(:db) { db }
        after(:all) { db.drop_schema :spec, cascade: true, if_exists: true }
      end
    end
    
    private
    def load_migration path
      Sequel.extension :migration
      require path
      Sequel::Migration.descendants.pop
    end

  end
end
