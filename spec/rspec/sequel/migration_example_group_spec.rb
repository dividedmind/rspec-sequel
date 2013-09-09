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
    
  end
end
