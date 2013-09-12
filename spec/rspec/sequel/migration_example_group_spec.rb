require 'spec_helper'

module RSpec::Sequel
  describe MigrationExampleGroup do
    
    it { should be_included_in_files_in('./spec/migrations/') }
    
    let :group do
      RSpec::Core::ExampleGroup.describe do
        include MigrationExampleGroup
      end
    end
    
    let(:instance) { group.new }
    
    describe '::db' do
      it "is an in-memory sqlite db by default" do
        instance.db.uri.should == 'sqlite:/'
      end

      it "can be overriden" do
        group.let(:db) { 'notreallyadb' }
        instance.db.should == 'notreallyadb'
      end
    end
    
    describe "#migrate!" do
      it "applies the migration in the proper direction" do
        migration = double "migration"
        instance.stub migration: migration, db: 'notreallyadb'
        
        migration.should_receive(:apply).with('notreallyadb', :dir)
        instance.migrate! :dir
      end
    end
    
    describe "::migration" do
      it "loads the migration from the migration_path" do
        instance.stub migration_path: File.expand_path("../test_migration.rb", __FILE__)
        
        instance.migration.up.call.should == "I'm up!"
        instance.migration.down.call.should == "I'm down!"
      end
    end
    
    describe "::migration_path" do
      it "defaults to the group title" do
        group.stub description: 'some/migration/path'
        instance.migration_path.should == "#{Dir.pwd}/some/migration/path"
      end
      
      it "uses the Rails root if available" do
        stub_const 'Rails', double(root: '/railroot')
        group.stub description: 'some/migration/path'
        instance.migration_path.should == "/railroot/some/migration/path"
      end
    end
    
    describe "::postgres_schema" do
      let(:postgres) { RSpec::Sequel::Test::postgres }
      
      it "connects to the same database as the model, only with 'spec' schema" do
        stub_const 'Sequel::DATABASES', [postgres]
        group.postgres_schema
        instance.db.opts.but(:orig_opts).should == postgres.opts.merge(search_path: %w(spec)).but(:orig_opts)
      end
      
      it "runs the code inside on the database with a clean schema before running the context" do
        stub_const 'Sequel::DATABASES', [postgres]
        group.postgres_schema do
          create_table :some_table do
            primary_key :id
          end
        end
        
        postgres.table_exists?(:spec__some_table).should be_false
        
        group.example { postgres.table_exists?(:spec__some_table).should be_true }
        reporter = RSpec::Core::Reporter.new
        reporter.should_receive :example_passed
        group.run(reporter)
        
        postgres.table_exists?(:spec__some_table).should be_false
      end
    end
    
  end
end
