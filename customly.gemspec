$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "customly/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "customly"
  s.version     = Customly::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Customly."
  s.description = "TODO: Description of Customly."
  s.license     = "MIT"


  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec", "~> 2.6"
end
