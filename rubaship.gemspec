# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rubaship/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["João Soares"]
  gem.email         = ["jsoaresgeral@gmail.com"]
  gem.description   = %q{Ruby implementation of the classic battleship game.}
  gem.summary       = %q{Ruby implementation of the classic battleship game offering an easy api to interact with.}
  gem.homepage      = "http://www.github.com/jasoares/rubaship"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rubaship"
  gem.require_paths = ["lib"]
  gem.version       = Rubaship::VERSION

  gem.add_development_dependency 'guard', '~> 1.0.1'
  gem.add_development_dependency 'rspec', '~> 2.9.0'
  gem.add_development_dependency 'guard-rspec', '~> 0.7.0'
  gem.add_development_dependency 'cucumber', '~>1.1.9'
  gem.add_development_dependency 'guard-cucumber', '~> 0.7.5'
  gem.add_development_dependency 'aruba', '~> 0.4.11'
  gem.add_development_dependency 'simplecov', '~> 0.6.3'
end
