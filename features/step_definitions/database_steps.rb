Given(/^an empty database$/) do
  RSpec::Sequel::Test.postgres.drop_schema :public, if_exists: true, cascade: true
  RSpec::Sequel::Test.postgres.create_schema :public
end
