require 'aruba/cucumber'

Before do
  step %q{a file named "spec/spec_helper.rb" with:}, %q{require 'rspec/sequel'}
end
