require 'spec_helper'

module RSpec::Sequel
  describe MigrationExampleGroup do
    
    it { should be_included_in_files_in('./spec/migrations/') }
    
    let :group do
      RSpec::Core::ExampleGroup.describe do
        include MigrationExampleGroup
      end
    end
    
    describe '::db' do
      it "is an in-memory sqlite db by default" do
        group.new.db.uri.should == 'sqlite:/'
      end

      it "can be overriden" do
        group.let(:db) { 'notreallyadb' }
        group.new.db.should == 'notreallyadb'
      end
    end
  end
end
