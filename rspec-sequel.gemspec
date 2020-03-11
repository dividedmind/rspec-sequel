# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/sequel/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-sequel"
  spec.version       = RSpec::Sequel::VERSION
  spec.authors       = ["Rafał Rzepecki"]
  spec.email         = ["rafal@conjur.net"]
  spec.description   = %q{Ever wanted to actually test that tricky migration? rspec-sequel will make it easy.}
  spec.summary       = %q{Easily spec Sequel migrations}
  spec.homepage      = "https://github.com/conjurinc/rspec-sequel"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "sequel", "~> 4.0"
  spec.add_dependency "rspec", "~> 3.9"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "cucumber", "~> 1.3"
  spec.add_development_dependency "aruba", "~> 0.5"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "pg", "~> 0.16"
end
