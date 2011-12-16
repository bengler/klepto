# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "klepto/version"

Gem::Specification.new do |s|
  s.name        = "klepto"
  s.version     = Klepto::VERSION
  s.authors     = ["Katrina Owen"]
  s.email       = ["katrina.owen@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A simple tool for transporting photos into Trove.}
  s.description = %q{A gem that provides the ability to sync photos from a local source (filesystem) to a Trove instance.}

  s.rubyforge_project = "klepto"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "httpclient"
end
