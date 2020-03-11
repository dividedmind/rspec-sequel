require 'spec_helper'

module RSpec::Sequel
  describe MigrationExampleGroup do
    let :group do
      RSpec::Core::ExampleGroup.describe do
        include MigrationExampleGroup
      end
    end
    
    let(:instance) { group.new }
    
    describe '::db' do
      it "is an in-memory sqlite db by default" do
        expect(instance.db.uri).to eq 'sqlite:/'
      end

      it "can be overriden" do
        group.let(:db) { 'notreallyadb' }
        expect(instance.db).to eq 'notreallyadb'
      end
    end
    
    describe "#migrate!" do
      it "applies the migration in the proper direction" do
        migration = double "migration"
        allow(instance).to receive_messages migration: migration, db: 'notreallyadb'
        
        expect(migration).to receive(:apply).with('notreallyadb', :dir)
        instance.migrate! :dir
      end
    end
    
    describe "::migration" do
      it "loads the migration from the migration_path" do
        allow(instance).to receive_messages migration_path: File.expand_path("../test_migration.rb", __FILE__)
        
        expect(instance.migration.up.call).to eq "I'm up!"
        expect(instance.migration.down.call).to eq "I'm down!"
      end
    end
    
    describe "::migration_path" do
      it "defaults to the group title" do
        allow(group).to receive_messages description: 'some/migration/path'
        expect(instance.migration_path).to eq "#{Dir.pwd}/some/migration/path"
      end
      
      it "uses the Rails root if available" do
        stub_const 'Rails', double(root: '/railroot')
        allow(group).to receive_messages description: 'some/migration/path'
        expect(instance.migration_path).to eq "/railroot/some/migration/path"
      end
    end
    
    describe "::postgres_schema" do
      let(:postgres) { RSpec::Sequel::Test::postgres }
      
      it "connects to the same database as the model, only with 'spec' schema" do
        stub_const 'Sequel::DATABASES', [postgres]
        group.postgres_schema
        expect(instance.db.opts.but(:orig_opts)).to eq postgres.opts.merge(search_path: %w(spec)).but(:orig_opts)
      end
      
      it "runs the code inside on the database with a clean schema before running the context" do
        stub_const 'Sequel::DATABASES', [postgres]
        group.postgres_schema do
          create_table :some_table do
            primary_key :id
          end
        end
        
        table_name = Sequel.qualify 'spec', 'some_table'
        expect(postgres.table_exists?(table_name)).to be false
        
        pg = postgres # ensure it's captured by the closure below
        group.example { expect(pg.table_exists?(table_name)).to be true }
        reporter = instance_double(RSpec::Core::Reporter).as_null_object
        expect(reporter).to receive :example_passed
        group.run(reporter)
        
        expect(postgres.table_exists?(table_name)).to be false
      end
    end
    
  end
end
