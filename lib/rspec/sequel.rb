require "rspec/sequel/version"

require "sequel"

require "rspec/sequel/migration_example_group"

RSpec::configure do |c|
  c.include RSpec::Sequel::MigrationExampleGroup, type: :migration, 
      example_group: { file_path: %r{spec/mig} }
end
