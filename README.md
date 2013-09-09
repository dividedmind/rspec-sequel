# RSpec::Sequel

Sometimes migrations are less than trivial, especially when they need to transform data instead of just reshaping the database.
That makes one justifiably uneasy when it comes to running them; the comfort provided by unit tests wasn't usually present or easy to attain. Until now!

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-sequel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-sequel

## Usage

    $ cat spec/migrations/create_users_spec.rb
    
```ruby
require 'spec_helper'

describe 'db/migrations/001_create_users.rb' do
  it "creates the users table" do
    migrate! :up
    db.table_exists?(:users).should be_true
    migrate! :down
    db.table_exists?(:users).should be_false
  end
end
```

## Credits

`spec/support/{matchers,helpers}.rb` originally come from [rspec-rails](https://github.com/rspec/rspec-rails).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
