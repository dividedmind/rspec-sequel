require 'spec_helper'

describe RSpec::Sequel do
  it 'should have a version number' do
    RSpec::Sequel::VERSION.should_not be_nil
  end

  it 'should do something useful' do
    false.should be_true
  end
end
