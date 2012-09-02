# -*- encoding: utf-8 -*-
require File.expand_path('../lib/town_crier/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brendon Murphy"]
  gem.email         = ["xternal1+github@gmail.com"]
  gem.summary       = %q{Multi Channel short announcement service for your organization}
  gem.description   = gem.summary
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "town_crier"
  gem.require_paths = ["lib"]
  gem.version       = TownCrier::VERSION

  gem.add_dependency "ohm"
  gem.add_dependency "ost"
  gem.add_dependency "pony"
  gem.add_dependency "rushover"
  gem.add_dependency "sinatra"
  gem.add_dependency "rack-parser"
  gem.add_dependency "twilio-ruby"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "flog"
  gem.add_development_dependency "guard-minitest"
  gem.add_development_dependency "rb-fsevent", "~> 0.9.1"
  gem.add_development_dependency "growl"
end
