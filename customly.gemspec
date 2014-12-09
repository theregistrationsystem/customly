$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "customly/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "customly"
  s.version     = Customly::VERSION
  s.authors     = ["Ahmad Hammad"]
  s.email       = ["ahmad@buttercloud.com"]
  s.homepage    = "http://www.buttercloud.com"
  s.summary     = "Summary of Customly."
  s.description = "Description of Customly."
  s.license     = "MIT"


  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")

  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "rails", ">= 4.1.0"
  s.add_dependency "carrierwave", "~> 0.10.0"

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rake', '>= 0.9.2'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-mocks'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "capybara"

end
