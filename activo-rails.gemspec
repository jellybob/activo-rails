# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activo-rails/version"

Gem::Specification.new do |s|
  s.name        = "activo-rails"
  s.version     = ActivoRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Wood"]
  s.email       = ["jon@blankpad.net"]
  s.homepage    = "http://github.com/jellybob/activo-rails"
  s.summary     = %q{Provides Rails integration for the Activo web app theme.}
  s.description = %q{Provides Rails integration for the Activo web app theme.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
