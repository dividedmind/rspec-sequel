module RSpec::Sequel
  module MigrationExampleGroup
    
    def self.included(base)
      base.class_eval do
        let(:db) { Sequel::connect 'sqlite:/' }
      end
    end

  end
end
