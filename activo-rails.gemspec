# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activo/rails/version"

Gem::Specification.new do |s|
  s.name        = "activo-rails"
  s.version     = Activo::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Wood"]
  s.email       = ["jon@blankpad.net"]
  s.homepage    = "http://github.com/jellybob/activo-rails"
  s.summary     = %q{Provides Rails integration for the Activo web app theme.}
  s.description = %q{Provides Rails integration for the Activo web app theme.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "actionpack"
  s.add_development_dependency "rails", ">= 3.1.0.beta1"
  s.add_development_dependency "jquery-rails", ">= 1.0.9"
  s.add_development_dependency "capybara", ">= 0.4.0"
  s.add_development_dependency "rspec-rails", ">= 2.0.0.beta"
end
