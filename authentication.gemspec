$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "authentication/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "authentication"
  s.version     = Authentication::VERSION
  s.authors     = ["test"]
  s.summary     = "single sign on application"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'bcrypt', '3.1.11'
  s.add_development_dependency 'rails', '5.1.4'
  s.add_development_dependency 'mysql2', '0.3.18'
  s.add_development_dependency 'rspec-rails', '3.5.2'
  s.add_development_dependency 'factory_girl_rails', '~> 4.7.0'
  s.add_development_dependency 'faker'

end
